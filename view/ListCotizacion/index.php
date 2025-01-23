<?php
	require_once("../../config/conexion.php");
	if(isset($_SESSION["con_id"])){
?>
<!DOCTYPE html>
<html lang="es" >
<head>
    <title>Cotizacion Transporte | Listado de Cotizacion</title>
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
                                    Listado de Cotizaciones
                                </h3>
                                <span class="kt-subheader__separator kt-hidden"></span> 
                                <div class="kt-subheader__breadcrumbs">
                                    <a href="#" class="kt-subheader__breadcrumbs-home"><i class="flaticon2-shelter"></i></a>
                                    <span class="kt-subheader__breadcrumbs-separator"></span> <a href="" class="kt-subheader__breadcrumbs-link"> Home </a> <span class="kt-subheader__breadcrumbs-separator"></span> <a href="" class="kt-subheader__breadcrumbs-link"> Cotización </a> <span class="kt-subheader__breadcrumbs-separator"></span> <a href="" class="kt-subheader__breadcrumbs-link"> Listado de Cotizaciones </a> 
                                </div>
                            </div>
                        </div>

                        <div class="kt-content kt-grid__item kt-grid__item--fluid" id="kt_content">
                            <div class="alert alert-light alert-elevate" role="alert">
                                <div class="alert-icon"><i class="flaticon-warning kt-font-brand"></i></div>
                                <div class="alert-text"> Solo podra interactuar con las cotizaciones que le pertenezcan. </div>
                            </div>
                            <div class="kt-portlet kt-portlet--mobile">
                                <div class="kt-portlet__head">
                                    <div class="kt-portlet__head-label">
                                        <h3 class="kt-portlet__head-title">
                                            Scrollable DataTable 
                                        </h3>
                                    </div>
                                </div>
                                <div class="kt-portlet__body">

                                    <table class="table table-striped- table-bordered table-hover table-checkable" id="lista_data">
                                        <thead>
                                            <tr>
                                                <th>Nro</th>
                                                <th>Cliente</th>
                                                <th>RUT</th>
                                                <th>Contacto</th>
                                                <th>Email</th>
                                                <th>Total</th>
                                                <th>Fech.Creación</th>
                                                <th>Estado</th>
                                                <th width="1%"></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                    </table>

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
    <script type="text/javascript" src="listcotizacion.js"></script>
    
</body>
</html>
<?php
	}else{
		header("Location:".Conectar::ruta()."index.php");
	}
?>