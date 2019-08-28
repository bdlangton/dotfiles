#!/usr/bin/php
<?php

/**
 * @file
 * Run GitBlameRemovals.
 */

require getenv('HOME') . '/.composer/vendor/autoload.php';

use Barrett\Git\GitBlameRemovals;

$console = new GitBlameRemovals($argv[1]);
$console->run();
