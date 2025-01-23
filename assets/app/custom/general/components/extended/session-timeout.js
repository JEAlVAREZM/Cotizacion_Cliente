"use strict";
var KTSessionTimeoutDemo = function () {

    var initDemo = function () {
        $.sessionTimeout({
            title: 'Notificación de Tiempo de Sesión Agotado', // Título de la notificación
            message: 'Tu sesión está a punto de caducar.', // Mensaje de la notificación
            redirUrl: 'http://localhost/Cotizacion_Cliente', // URL de redirección después de que la sesión caduque
            logoutUrl: 'http://localhost/Cotizacion_Cliente/view/html/logout.php', // URL de cierre de sesión
            warnAfter: 10000, // Advertir después de 3 segundos (3000 milisegundos)
            redirAfter: 35000, // Redirigir después de 35 segundos (35000 milisegundos)
            ignoreUserActivity: true, // Ignorar la actividad del usuario (por defecto, verdadero)
            countdownMessage: 'Redireccionando en {timer} segundos.', // Mensaje de cuenta regresiva de redirección
            countdownBar: true // Mostrar una barra de cuenta regresiva (por defecto, verdadero)
        });
    }

    return {
        //main function to initiate the module
        init: function () {
            initDemo();
        }
    };

}();



jQuery(document).ready(function() {
    
    $(document).on('sessionTimeout.dialogopen', function () {
        // Encuentra los botones por su texto y cambia el texto según tus necesidades
        $('.ui-dialog-buttonpane button:contains("Stay Connected")').text('Mantener sesión');
        $('.ui-dialog-buttonpane button:contains("Logout")').text('Cerrar sesión');
    });
    KTSessionTimeoutDemo.init();
});