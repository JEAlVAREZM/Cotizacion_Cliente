<div id="kt_header" class="kt-header kt-grid__item kt-header--fixed " >
    <button class="kt-header-menu-wrapper-close" id="kt_header_menu_mobile_close_btn"><i class="la la-close"></i></button>
    <div class="kt-header-menu-wrapper" id="kt_header_menu_wrapper">
        <div id="kt_header_menu" class="kt-header-menu kt-header-menu-mobile kt-header-menu--layout- " >
            <ul class="kt-menu__nav ">

            </ul>
        </div>
    </div>

    <div class="kt-header__topbar">
        <div class="kt-header__topbar-item">
            <div class="kt-header__topbar-wrapper" id="kt_offcanvas_toolbar_quick_actions_toggler_btn">
                <span class="kt-header__topbar-icon"><i class="flaticon2-gear"></i></span>
            </div>
        </div>

        <div class="kt-header__topbar-item kt-header__topbar-item--langs">
            <div class="kt-header__topbar-wrapper" data-toggle="dropdown" data-offset="10px,0px">
                <span class="kt-header__topbar-icon">
                    <img class="" src="../../assets/media/flags/016-spain.svg" alt="" />
                </span>
            </div>
            <div class="dropdown-menu dropdown-menu-fit dropdown-menu-right dropdown-menu-anim dropdown-menu-top-unround">
                <ul class="kt-nav kt-margin-t-10 kt-margin-b-10">
                    <li class="kt-nav__item">
                        <a href="#" class="kt-nav__link" data-lang="en">
                            <span class="kt-nav__link-icon">
                                <img src="../../assets/media/flags/020-flag.svg" alt="" />
                            </span>
                            <span class="kt-nav__link-text">English</span>
                        </a>
                    </li>
                    <li class="kt-nav__item">
                        <a href="#" class="kt-nav__link" data-lang="es">
                            <span class="kt-nav__link-icon">
                                <img src="../../assets/media/flags/016-spain.svg" alt="" />
                            </span>
                            <span class="kt-nav__link-text">Spanish</span>
                        </a>
                    </li>
                    <li class="kt-nav__item">
                        <a href="#" class="kt-nav__link" data-lang="de">
                            <span class="kt-nav__link-icon">
                                <img src="../../assets/media/flags/017-germany.svg" alt="" />
                            </span>
                            <span class="kt-nav__link-text">German</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <div class="kt-header__topbar-item kt-header__topbar-item--user">
            <div class="kt-header__topbar-wrapper" data-toggle="dropdown" data-offset="0px, 0px">
                <div class="kt-header__topbar-user">
                    <span class="kt-header__topbar-welcome kt-hidden-mobile">Hola,</span> <span class="kt-header__topbar-username kt-hidden-mobile"><?php echo $_SESSION["con_nom"]?></span> 
                    <img alt="Pic" src="../../assets/media/users/default.jpg" />
                    <span class="kt-badge kt-badge--username kt-badge--lg kt-badge--brand kt-hidden kt-badge--bold">S</span> 
                </div>
            </div>
            <div class="dropdown-menu dropdown-menu-fit dropdown-menu-right dropdown-menu-anim dropdown-menu-top-unround dropdown-menu-sm">
                <div class="kt-user-card kt-margin-b-50 kt-margin-b-30-tablet-and-mobile" style="background-image: url(../../assets/media/misc/head_bg_sm.jpg)">
                    <div class="kt-user-card__wrapper">
                        <div class="kt-user-card__pic">
                            <img alt="Pic" src="../../assets/media/users/default.jpg" />
                        </div>
                        <div class="kt-user-card__details">
                            <div class="kt-user-card__name"><?php echo $_SESSION["con_nom"]?></div>
                            <div class="kt-user-card__position"><?php echo $_SESSION["cli_nom"]?></div>
                        </div>
                    </div>
                </div>
                <ul class="kt-nav kt-margin-b-10">
                    <li class="kt-nav__item">
                        <a href="custom_user_profile-v1.html" class="kt-nav__link">
                            <span class="kt-nav__link-icon"><i class="flaticon2-calendar-3"></i></span>
                            <span class="kt-nav__link-text">Mi Perfil</span> 
                        </a>
                    </li>
                    <li class="kt-nav__item kt-nav__item--custom kt-margin-t-15"> 
                        <a href="../html/logout.php" class="btn btn-outline-metal btn-hover-brand btn-upper btn-font-dark btn-sm btn-bold">Cerrar Sesion</a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="kt-header__topbar-item kt-header__topbar-item--quick-panel" data-toggle="kt-tooltip" title="Quick panel" data-placement="right">
            <span class="kt-header__topbar-icon" id="kt_quick_panel_toggler_btn"> <i class="flaticon2-grids"></i> </span>
        </div>
    </div>
</div>