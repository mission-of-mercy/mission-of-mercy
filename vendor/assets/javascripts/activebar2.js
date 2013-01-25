/**
 * This file is part of Activebar2.
 *
 * Activebar2 is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3 of the License.
 *
 * Activebar2 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Activebar2; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * You may contact the author by mail: jakob@php.net
 *
 * Or write to:
 * Jakob Westhoff
 * Kleiner Floraweg 35
 * 44229 Dortmund
 * Germany
 *
 * The latest version of ActiveBar can be obtained from:
 * http://www.westhoffswelt.de/
 *
 * @package Core
 * @version $Revision$
 * @license http://www.gnu.org/licenses/gpl-3.0.txt GPL
 */
(function($) {

    $.fn.activebar = function( options ) {
        // Merge the specified options with the default ones
        var options = $.fn.extend( {}, $.fn.activebar.defaults, options );

        // Create a new activebar container if there is no one lying around
        if ( $.fn.activebar.container == null ) {
            $.fn.activebar.container = initializeActivebar( options );
        }

        // Update the style values according to the provided options
        setOptionsOnContainer( $.fn.activebar.container, options );

        // If the activebar is currently visible hide it
        $.fn.activebar.hide();

        // Remove all elements from the activebar content, which might be there
        $( '.content', $.fn.activebar.container ).empty();

        // Use all provided elements as new content source
        $(this).each( function() {
            $( '.content', $.fn.activebar.container ).append( this );
        });

        // Remove any "gotoURL" function
        $.fn.activebar.container.unbind( 'click' );

        // Add a new "gotoURL" function if one has been supplied
        if( options.url != null ) {
            $.fn.activebar.container.click(
                function() {
                    window.location.href = options.url;
                }
            );
        }

        // Update the position based on the new content data height
        $.fn.activebar.container.css( 'top', '-' + $.fn.activebar.container.height() + 'px' );

        // Show the activebar
        $.fn.activebar.show();
    };

    /**
     * Default options used if nothing more specific is provided.
     */
    $.fn.activebar.defaults = {
        'background': 'InfoBackground',
        'border': '#c8c8c8',
        'highlight': 'Highlight',
        'font': 'Bitstream Vera Sans,verdana,sans-serif',
        'fontColor': 'InfoText',
        'fontSize': '12px',
        'icon': 'assets/activebar-information.png',
        'button': 'assets/activebar-closebtn.png',
        'url': null
    };

    /**
     * Indicator in which state the activebar currently is
     * 0: Moved in (hidden)
     * 1: Moving in (hiding)
     * 2: Moving out (showing)
     * 3: Moved out (shown)
     */
    $.fn.activebar.state = 0;

    /**
     * Activebar container object which holds the shown content
     */
    $.fn.activebar.container = null;

    /**
     * Show the activebar by moving it in
     */
    $.fn.activebar.show = function() {
        if ( $.fn.activebar.state > 1 ) {
            // Already moving out or visible. Do Nothing.
            return;
        }

        $.fn.activebar.state = 2;
        $.fn.activebar.container.css( 'display', 'block' );

        var height = $.fn.activebar.container.height();
        $.fn.activebar.container.animate({
            'top': '+=' + height + 'px'
        }, height * 20, 'linear', function() {
            $.fn.activebar.state = 3;
        });
    };

    /**
     * Hide the activebar by moving it out
     */
    $.fn.activebar.hide = function() {
        if ( $.fn.activebar.state < 2 ) {
            // Already moving in or hidden. Do nothing.
            return;
        }

        $.fn.activebar.state = 1;

        var height   = $.fn.activebar.container.height();
        $.fn.activebar.container.animate({
            'top': '-=' + height + 'px'
        }, height * 20, 'linear', function() {
            $.fn.activebar.container.css( 'display', 'none' );
            $.fn.activebar.visible = false;
        });
    };

    $.fn.activebar.updateBar = function(options){
      var options = $.fn.extend( {}, $.fn.activebar.defaults, options );
      setOptionsOnContainer( $.fn.activebar.container, options );
    }

    /****************************************************************
     * Private function only accessible from within this plugin
     ****************************************************************/

     /**
      * Create the a basic activebar container object and return it
      */
     function initializeActivebar( options ) {
        // Create the container object
        var container = $( '<div></div>' ).attr( 'id', 'activebar-container' );

        // Set the needed css styles
        container.css({
            'display': 'none',
            'position': 'fixed',
            'zIndex': '9999',
            'top': '0px',
            'left': '0px'
        });

        // Make sure the bar has always the correct width
        $(window).bind( 'resize', function() {
            container.width( $(this).width() );
        });

        // Set the initial bar width
        $(window).trigger( 'resize' );

        // The IE prior to version 7.0 does not support position fixed. However
        // the correct behaviour can be emulated using a hook to the scroll
        // event. This is a little choppy, but it works.
        if ( $.browser.msie
          && ( $.browser.version.substring( 0, 1 ) == '5'
            || $.browser.version.substring( 0, 1 ) == '6' ) ) {
            // Position needs to be changed to absolute, because IEs fallback
            // for fixed is static, which is quite useless here.
            container.css( 'position', 'absolute' );
            $( window ).scroll(
                function() {
                    container.stop( true, true );
                    if ( $.fn.activebar.state == 3 ) {
                        // Activebar is visible
                        container.css( 'top', $( window ).scrollTop() + 'px' );
                    }
                    else {
                        // Activebar is hidden
                        container.css( 'top', ( $( window ).scrollTop() - container.height() ) + 'px' );
                    }
                }
            );
        }

        // Add the icon container
        container.append(
            $( '<div></div>' ).attr( 'class', 'icon' )
                              .css({
                                'float': 'left',
                                'width': '16px',
                                'height': '16px',
                                'margin': '6px 4px 4px 4px'
                              })
        );

        // Add the close button
        container.append(
            $( '<div></div>' ).attr( 'class', 'close' )
                              .css({
                                'float': 'right',
                                'margin': '6px 4px 4px 4px',
                                'width': '16px',
                                'height': '16px',
                                'cursor': 'pointer'
                              })
                              .click(
                                function(event) {
                                    $.fn.activebar.hide();
                                    event.stopPropagation();
                                }
                              )
        );

        // Create the initial content container
        container.append(
            $( '<div></div>' ).attr( 'class', 'content' )
                              .css({
                                'margin': '4px 28px 4px 28px'
                              })
        );

        $('body').prepend( container );

        return container;
     };

     /**
      * Set the provided options on the given activebar container object
      */
     function setOptionsOnContainer( container, options ) {
         container.css({
            'background': options.background,
            'borderBottom': '1px solid ' + options.border
         });

        // Register functions to change between normal and highlight background
        // color on mouseover
        container.unbind( 'mouseenter mouseleave' );
        container.hover(
            function() {
                $(this).css( 'backgroundColor', options.highlight );
            },
            function() {
                $(this).css( 'backgroundColor', options.background );
            }
        );

        // Set the correct icon image
        $( '.icon', container ).css( 'background', 'transparent url( \'' + options.icon  + '\' ) top left no-repeat' );

        // Remove any links
        $( '.close', container ).unbind( 'click' );

        // Set the close button image
        $( '.close', container ).css( 'background', 'transparent url( \'' + options.button + '\' ) top left no-repeat' ).click(function(event){
            $.fn.activebar.hide();
            event.stopPropagation();
            if(options.onClose) options.onClose();
        });

        // Set the content font styles
        $( '.content', container ).css({
            'color': options.fontColor,
            'fontFamily': options.font,
            'fontSize': options.fontSize
        });
     };

})(jQuery);
