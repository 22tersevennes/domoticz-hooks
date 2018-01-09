<?php

require_once __DIR__ . '/config.php';

class Logs {

    private $ident = "";
    private $debug = false;

    function __construct($ident="(?)", $facility=LOG_NOTICE)
    {
        openlog($ident, LOG_ODELAY|LOG_CONS, $facility);
        $this->debug = getenv("DEBUG") != "";
    }
    
    function Debug($msg)
    {
        if ($this->debug) $this->Write($msg, LOG_DEBUG);
    }
    
    function Info($msg)
    {
        $this->Write($msg, LOG_INFO);
    }
    
    function Error($msg)
    {
        $this->Write($msg, LOG_ERR);
    }
    
    function Write($msg, $facility=LOG_NOTICE)
    {
        syslog($facility, $msg);
    }
}