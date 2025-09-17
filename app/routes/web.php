<?php
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome'); // include welcome view or simple index
});

Route::get('/healthz', function () {
    return response('OK', 200);
});
