<?php
	require_once("config/conexion.php");
	if(isset($_POST["enviar"]) and $_POST["enviar"]=="si"){
		require_once("models/Contacto.php");
		$contacto = new Contacto();
		$contacto -> login();
	}
?>
<!DOCTYPE html>
<html lang="es" >
<head>
    <meta charset="utf-8"/>
    <title>Cotizacion Transporte| Cliente</title>
    <meta name="description" content="User login example">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <script src="https://ajax.googleapis.com/ajax/libs/webfont/1.6.16/webfont.js"></script>
    <script>
        WebFont.load({

            google: {
                "families":[
                "Poppins:300,400,500,600,700"]
            },
            active: function() {
                sessionStorage.fonts = true;
            }
        });
    </script>
    <link href="assets/app/custom/user/login-v2.default.css" rel="stylesheet" type="text/css" />
    <link href="assets/vendors/general/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" type="text/css" />
    <link href="assets/demo/default/base/style.bundle.css" rel="stylesheet" type="text/css" />
    <link href="assets/demo/default/skins/header/base/light.css" rel="stylesheet" type="text/css" />
    <link href="assets/demo/default/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
    <link href="assets/demo/default/skins/brand/navy.css" rel="stylesheet" type="text/css" />
    <link href="assets/demo/default/skins/aside/navy.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
</head>
    <body class="kt-login-v2--enabled kt-header--fixed kt-header-mobile--fixed kt-subheader--enabled kt-subheader--transparent kt-aside--enabled kt-aside--fixed kt-page--loading" >
        <div class="kt-grid kt-grid--ver kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid kt-grid--hor kt-login-v2" id="kt_login_v2">
                <div class="kt-grid__item kt-grid--hor">
                    <div class="kt-login-v2__head">
                        <div class="kt-login-v2__logo">
                            <a href="#">
                                <h3>Transportes<strong>Tranes</strong></h3>
                            </a>
                        </div>
                        <div class="kt-login-v2__signup"> <span>No tiene cuenta?</span> <a href="#" class="kt-link kt-font-brand">Registrarse</a> </div>
                    </div>
                </div>

                <div class="kt-grid__item kt-grid kt-grid--ver kt-grid__item--fluid">
                    <div class="kt-login-v2__body">
                        <div class="kt-login-v2__wrapper">
                            <div class="kt-login-v2__container">
                                <div class="kt-login-v2__title">
                                    <h3>
                                        Acceder
                                    </h3>
                                </div>

                                <form action="" method="post" class="kt-login-v2__form kt-form" autocomplete="off">
                                    <div class="form-group">
                                        <input class="form-control" type="text" placeholder="Correo Electronico" id="con_email" name="con_email" autocomplete="off">
                                    </div>
                                    <div class="form-group">
                                        <input class="form-control" type="password" placeholder="Contraseña" id="con_pass" name="con_pass" autocomplete="off">
                                    </div>

                                    <div class="kt-login-v2__actions">
                                        <input type="hidden" name="enviar" value="si">
                                        <a href="#" class="kt-link kt-link--brand"> Recuperar Contraseña ? </a> 
                                        <button type="submit" class="btn btn-brand btn-elevate btn-pill">Acceder</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="kt-login-v2__image">
                            <img src="assets/media/misc/bg_icon-1.svg" alt="">
                        </div>

                    </div>

                </div>

                <div class="kt-grid__item">
                    <div class="kt-login-v2__footer">
                        <div class="kt-login-v2__link"> <a href="#" class="kt-link kt-font-brand">Privacidad</a> <a href="#" class="kt-link kt-font-brand">Legal</a> <a href="#" class="kt-link kt-font-brand">Contacto</a> </div>
                        <div class="kt-login-v2__info"> <a href="#" class="kt-link">&copy; Transportes Tranes</a> </div>
                    </div>
                </div>

            </div>
        </div>

    <script>
        var KTAppOptions = {
            "colors": {
                "state": {
                    "brand": "#5d78ff",
                    "metal": "#c4c5d6",
                    "light": "#ffffff",
                    "accent": "#00c5dc",
                    "primary": "#5867dd",
                    "success": "#34bfa3",
                    "info": "#36a3f7",
                    "warning": "#ffb822",
                    "danger": "#fd3995",
                    "focus": "#9816f4"
                },
                "base": {
                    "label": [
                        "#c5cbe3",
                        "#a1a8c3",
                        "#3d4465",
                        "#3e4466"
                    ],
                    "shape": [
                        "#f0f3ff",
                        "#d9dffa",
                        "#afb4d4",
                        "#646c9a"
                    ]
                }
            }
        };
    </script>
    <script src="assets/vendors/general/jquery/dist/jquery.js" type="text/javascript"></script>
    <script src="assets/vendors/general/popper.js/dist/umd/popper.js" type="text/javascript"></script>
    <script src="assets/vendors/general/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="assets/vendors/general/js-cookie/src/js.cookie.js" type="text/javascript"></script>
    <script src="assets/vendors/general/moment/min/moment.min.js" type="text/javascript"></script>
    <script src="assets/vendors/general/tooltip.js/dist/umd/tooltip.min.js" type="text/javascript"></script>
    <script src="assets/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js" type="text/javascript"></script>
    <script src="assets/vendors/general/sticky-js/dist/sticky.min.js" type="text/javascript"></script>
    <script src="assets/vendors/general/wnumb/wNumb.js" type="text/javascript"></script>
    <script src="assets/demo/default/base/scripts.bundle.js" type="text/javascript"></script>
    <script src="assets/app/custom/general/custom/login/login.js" type="text/javascript"></script>
    <script src="assets/app/bundle/app.bundle.js" type="text/javascript"></script>
</body>
</html>