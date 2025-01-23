<?php
	require_once("../../config/conexion.php");
	if(isset($_SESSION["con_id"])){
?>
<!DOCTYPE html>
<html lang="es" >
<head>
    <title>Cotizacion Transporte | Home</title>
    <?php require_once("../html/head.php")?>
</head>
    <body class="kt-header--fixed kt-header-mobile--fixed kt-subheader--enabled kt-subheader--transparent kt-aside--enabled kt-aside--fixed kt-page--loading" >

        <?php require_once("../html/headermovile.php")?>

        <div class="kt-grid kt-grid--hor kt-grid--root">
            <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
                <button class="kt-aside-close " id="kt_aside_close_btn"><i class="la la-close"></i></button>

                <?php require_once("../html/menu.php")?>

                <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor kt-wrapper" id="kt_wrapper">

                    <?php require_once("../html/header.php")?>

                    <div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
                        <div class="kt-subheader kt-grid__item" id="kt_subheader">
                            <div class="kt-subheader__main">
                                <h3 class="kt-subheader__title">
                                    Dashboard
                                </h3>
                                <span class="kt-subheader__separator kt-hidden"></span> 
                                <div class="kt-subheader__breadcrumbs">
                                    <a href="#" class="kt-subheader__breadcrumbs-home"><i class="flaticon2-shelter"></i></a>
                                    <span class="kt-subheader__breadcrumbs-separator"></span> <a href="#" class="kt-subheader__breadcrumbs-link"> Home </a> <span class="kt-subheader__breadcrumbs-separator"></span> <a href="#" class="kt-subheader__breadcrumbs-link"> Dashboard </a> <span class="kt-subheader__breadcrumbs-separator"></span>
                                </div>
                            </div>
                        </div>

                        <div class="kt-content kt-grid__item kt-grid__item--fluid" id="kt_content"> 

                            <div class="row">

                                <div class="col-lg-4 col-xl-4 order-lg-1 order-xl-1">
                                    <div class="kt-portlet kt-portlet--fit kt-portlet--height-fluid">
                                        <div class="kt-portlet__body kt-portlet__body--fluid">
                                            <div class="kt-widget-3 kt-widget-3--success">
                                                <div class="kt-widget-3__content">
                                                    <div class="kt-widget-3__content-info">
                                                        <div class="kt-widget-3__content-section">
                                                            <div class="kt-widget-3__content-title">Cotización</div>
                                                            <div class="kt-widget-3__content-desc">Total Aceptadas</div>
                                                        </div>
                                                        <div class="kt-widget-3__content-section">
                                                            <span class="kt-widget-3__content-number" id="lblaceptada"></span>
                                                        </div>
                                                    </div>
                                                    <div class="kt-widget-3__content-stats">
                                                        <div class="kt-widget-3__content-progress">

                                                        </div>
                                                        <div class="kt-widget-3__content-action">

                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--end::Portlet-->
                                </div>

                                <div class="col-lg-4 col-xl-4 order-lg-1 order-xl-1">
                                    <div class="kt-portlet kt-portlet--fit kt-portlet--height-fluid">
                                        <div class="kt-portlet__body kt-portlet__body--fluid">
                                            <div class="kt-widget-3 kt-widget-3--focus">
                                                <div class="kt-widget-3__content">
                                                    <div class="kt-widget-3__content-info">
                                                        <div class="kt-widget-3__content-section">
                                                            <div class="kt-widget-3__content-title">Cotización</div>
                                                            <div class="kt-widget-3__content-desc">Total Pendientes</div>
                                                        </div>
                                                        <div class="kt-widget-3__content-section">
                                                            <span class="kt-widget-3__content-number" id="lblpendiente"></span>
                                                        </div>
                                                    </div>
                                                    <div class="kt-widget-3__content-stats">
                                                        <div class="kt-widget-3__content-progress">

                                                        </div>
                                                        <div class="kt-widget-3__content-action">

                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-4 col-xl-4 order-lg-1 order-xl-1">
                                    <div class="kt-portlet kt-portlet--fit kt-portlet--height-fluid">
                                        <div class="kt-portlet__body kt-portlet__body--fluid">
                                            <div class="kt-widget-3 kt-widget-3--danger">
                                                <div class="kt-widget-3__content">
                                                    <div class="kt-widget-3__content-info">
                                                        <div class="kt-widget-3__content-section">
                                                            <div class="kt-widget-3__content-title">Cotización</div>
                                                            <div class="kt-widget-3__content-desc">Total Rechazadas</div>
                                                        </div>
                                                        <div class="kt-widget-3__content-section">
                                                            <span class="kt-widget-3__content-number" id="lblrechazado"></span>
                                                        </div>
                                                    </div>
                                                    <div class="kt-widget-3__content-stats">
                                                        <div class="kt-widget-3__content-progress">

                                                        </div>
                                                        <div class="kt-widget-3__content-action">

                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-lg-12">

                                    <div class="kt-portlet" id="kt_portlet">
                                        <div class="kt-portlet__head kt-portlet__head--lg">
                                            <div class="kt-portlet__head-label">
                                                <span class="kt-portlet__head-icon"> <i class="flaticon-map-location"></i> </span>
                                                <h3 class="kt-portlet__head-title">
                                                    Calendario
                                                </h3>
                                            </div>
                                        </div>
                                        <div class="kt-portlet__body">
                                            <div id="data_calendar">
                                                
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                        </div>
                    </div>

                    <?php require_once("../html/footer.php")?>

                </div>
            </div>
        </div>

        <?php require_once("../html/toolbar.php")?>

        <?php require_once("../html/timeline.php")?>

        <div id="kt_scrolltop" class="kt-scrolltop"> <i class="la la-arrow-up"></i> </div>

    <?php require_once("../html/js.php")?>
    <script type="text/javascript" src="home.js"></script>
    
</body>
</html>
<?php
	}else{
		header("Location:".Conectar::ruta()."index.php");
	}
?>