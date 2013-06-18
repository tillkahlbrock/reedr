<?php

require_once "../bin/bootstrap.php";

$app = new \Slim\Slim();

$app->get('/', function () use($app) {
    $app->render('start.php');
});

$app->run();



?>
