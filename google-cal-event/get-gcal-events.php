#!/usr/bin/env php
<?php

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/Log.class.php';

if (php_sapi_name() != 'cli') {
  throw new Exception('This application must be run on the command line.');
}

$log = new Logs("g-events");

/**
 * Returns an authorized API client.
 * @return Google_Client the authorized client object
 */
function getClient() {
  $client = new Google_Client();
  $client->setApplicationName(APPLICATION_NAME);
  $client->setScopes(SCOPES);
  $client->setAuthConfig(CLIENT_SECRET_PATH);
  $client->setAccessType('offline');

  // Load previously authorized credentials from a file.
  $credentialsPath = expandHomeDirectory(CREDENTIALS_PATH);
  if (file_exists($credentialsPath)) {
    $accessToken = json_decode(file_get_contents($credentialsPath), true);
  } else {
    // Request authorization from the user.
    $authUrl = $client->createAuthUrl();
    printf("Open the following link in your browser:\n%s\n", $authUrl);
    print 'Enter verification code: ';
    $authCode = trim(fgets(STDIN));

    // Exchange authorization code for an access token.
    $accessToken = $client->fetchAccessTokenWithAuthCode($authCode);

    // Store the credentials to disk.
    if(!file_exists(dirname($credentialsPath))) {
      mkdir(dirname($credentialsPath), 0700, true);
    }
    file_put_contents($credentialsPath, json_encode($accessToken));
    printf("Credentials saved to %s\n", $credentialsPath);
  }
  $client->setAccessToken($accessToken);

  // Refresh the token if it's expired.
  if ($client->isAccessTokenExpired()) {
    $client->fetchAccessTokenWithRefreshToken($client->getRefreshToken());
    file_put_contents($credentialsPath, json_encode($client->getAccessToken()));
  }
  return $client;
}

/**
 * Expands the home directory alias '~' to the full path.
 * @param string $path the path to expand.
 * @return string the expanded path.
 */
function expandHomeDirectory($path) {
  $homeDirectory = getenv('HOME');
  if (empty($homeDirectory)) {
    $homeDirectory = getenv('HOMEDRIVE') . getenv('HOMEPATH');
  }
  return str_replace('~', realpath($homeDirectory), $path);
}

$log->Info("Authenticated, start retrieving events");

// Get the API client and construct the service object.
$client = getClient();
$service = new Google_Service_Calendar($client);

// Print the next 10 events on the user's calendar.
$calendarId = 'primary';

$now = time();

// retrieve event for the next 24 heours
$optParams = array(
  'singleEvents' => true,
  'showDeleted' => false,
  'timeMin' => date('c', $now),
  'timeMax' => date('c', $now+GCAL_RETRIEVING_INTERVAL_SECS)
);

$results = $service->events->listEvents($calendarId, $optParams);
    
$gcalevents = array();
$gevents = array();
if (count($results->getItems()) > 0) {
    foreach ($results->getItems() as $event) {
      $log->Debug(
        sprintf(
          '[%s] %s > %s (%s) %s', 
          $event->id, 
          $event->startTime, 
          $event->endTime, 
          $event->getSummary(), 
          $event->status
        )
      );
      $gcalevents[] = $event;
      $start = $event->start->dateTime ? $event->start->dateTime : $event->start->date;
      $end = $event->end->dateTime ? $event->end->dateTime : $event->end->date;
      $gevents[] = array(
       'summary' => $event->getSummary(),
       'start'  => $start,
       'end'    => $end,
       'start_m'  => strtotime($start),
       'end_m'    => strtotime($end),
       'allday' => $event->start->dateTime ? false : true,
        'id'     => $event->id
      );
    }
    if (getenv("DEBUG")) {
      $f = fopen(EVENT_LOCAL_STORAGE.'.original', "w");
      fwrite($f, json_encode($gcalevents, JSON_FORCE_OBJECT|JSON_PRETTY_PRINT));
      fclose($f);
    }
    $f = fopen(EVENT_LOCAL_STORAGE, "w");
    fwrite($f, json_encode($gevents, JSON_FORCE_OBJECT|JSON_PRETTY_PRINT));
    fclose($f);

  }
  
$log->Info(
    sprintf(
      "From %s to %s: %d upcoming events retrieved.",
      strftime("%d/%m/%y %H:%M", $now),
      strftime("%d/%m/%y %H:%M", $now+GCAL_RETRIEVING_INTERVAL_SECS),
      count($gcalevents)
    )
  );

exit(0);