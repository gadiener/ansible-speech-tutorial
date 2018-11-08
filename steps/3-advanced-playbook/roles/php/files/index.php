<?php
$host = !empty($_SERVER['HTTP_X_FORWARDED_HOST']) ? $_SERVER['HTTP_X_FORWARDED_HOST'] : exec('hostname');
$title = "Hello, I'm {$host}!";
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title><?= $title ?></title>
    </head>
    <body>
        </br>
        <h1 align='center'>
            <?= $title ?>
        </h1>
        </br>
        </br>

        <?php phpinfo(); ?>
    </body>
</html>