$(document).ready(function() {

    function changeLanguage(lang){
        $.getJSON('../../assets/traduccion.json',function(data){
            var translations = data[lang];
            var flagName = translations["flag"];

            $('[data-transtale]').each(function(){
                var key = $(this).data('transtale');
                var translatetext = translations[key] || key;
                $(this).find('.kt-menu__link-text').html(translatetext);
            });

            var flagSrc = '../../assets/media/flags/'+flagName;
            $('.kt-header__topbar-icon img').attr('src',flagSrc);

        });
    }

    $('.kt-nav__link').on('click',function(e){
        e.preventDefault();
        var lang=$(this).data('lang');
        changeLanguage(lang);
    });

});