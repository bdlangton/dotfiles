#!/usr/bin/php
<?php

/**
 * @file
 * Run GitBlameRemovals.
 */

require getenv('HOME') . '/.composer/vendor/autoload.php';
require 'GitBlameRemovals.php';

$console = new GitBlameRemovals($argv[1]);
$console->run();
