<?php

require_once __DIR__ . '/vendor/autoload.php';

// Google access
define('APPLICATION_NAME', 'Domoticz Google Calendar Management');
define('SYNC_TOKEN_PATH', __DIR__ . '/.sync.token');
define('CREDENTIALS_PATH', '~/.credentials/google.json');
define('CLIENT_SECRET_PATH', __DIR__ . '/secret.json');
define('SCOPES', 
  implode(
    ' ', 
    array(
        Google_Service_Calendar::CALENDAR_READONLY
      )
    )
);

// Domoticz root dir
define('DOMOTICZ_ROOT_DIR', '/home/pi/domoticz');
// Local storage for event
define('EVENT_LOCAL_STORAGE', DOMOTICZ_ROOT_DIR . '/g-events.json');
// DB file for orders
define('ORDERS_DB_FILE', DOMOTICZ_ROOT_DIR . '/g-events.sqlite3');

// Interval (hours) for events getting
define('GCAL_RETRIEVING_INTERVAL_SECS', 7*24*3600);