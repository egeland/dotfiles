function fish-apple-touchbar
    if not status is-interactive
        exit 0
    end
    function __fish_apple_touchbar_first_view
        function bind_keys_function
            __fish_apple_touchbar_bind_key 1 'saml2aws' 'saml2aws login --force'
            __fish_apple_touchbar_bind_key 2 'kubectx' 'kubectx'
            # __fish_apple_touchbar_bind_key 3 'third view' '__fish_apple_touchbar_third_view'
        end

        __fish_apple_touchbar_create_view 'first' bind_keys_function
    end

    function __fish_apple_touchbar_second_view
        function bind_keys_function
            __fish_apple_touchbar_bind_key 1 '👈 back' '__fish_apple_touchbar_first_view'
            __fish_apple_touchbar_bind_key 2 'current path' "pwd" '-s'
        end

        __fish_apple_touchbar_create_view 'second' bind_keys_function
    end

    function __fish_apple_touchbar_third_view
        function bind_keys_function
            __fish_apple_touchbar_bind_key 1 '👈 back' '__fish_apple_touchbar_first_view'
            __fish_apple_touchbar_bind_key 2 'ls' "ls -la" '-s'
        end

        __fish_apple_touchbar_create_view 'third' bind_keys_function
    end
end
