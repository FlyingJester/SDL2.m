:- module sdl2.
:- interface.
:- import_module string.

:- type size ---> size(w::int, h::int).
:- type point ---> point(x::int, y::int).
:- type rect ---> rect(origin::point, size).

:- type surface.
:- type pixel_format.
:- type color.
:- type surface.
:- type window.

%===============================================================================
%=== SDL2 Events for Mercury
%===============================================================================

% Mouse
:- type button ---> left ; middle ; right.

% Keys
:- type key ---> key_unknown ;
    key_return ;
    key_escape ;
    key_backspace ;
    key_tab ;
    key_space ;
    key_exclamation ;
    key_doublequote ;
    key_octothorp ;
    key_percent ;
    key_dollar ;
    key_ampersand ;
    key_quote ;
    key_openparen ;
    key_closeparen ;
    key_asterisk ;
    key_plus ;
    key_minus ;
    key_comma ;
    key_period ;
    key_slash ;
    key_zero ;
    key_one ;
    key_two ;
    key_three ;
    key_four ;
    key_five ;
    key_six ;
    key_seven ;
    key_eight ;
    key_nine ;
    key_semicolon ;
    key_colon ;
    key_lessthan ;
    key_greaterthan ;
    key_question ;
    key_openbracket ;
    key_closebracket ;
    key_backslash ;
    key_caret ;
    key_underscore ;
    key_grave ;
    key_at ;
    key_a ;
    key_b ;
    key_c ;
    key_d ;
    key_e ;
    key_f ;
    key_g ;
    key_h ;
    key_i ;
    key_j ;
    key_k ;
    key_l ;
    key_m ;
    key_n ;
    key_o ;
    key_p ;
    key_q ;
    key_r ;
    key_s ;
    key_t ;
    key_u ;
    key_v ;
    key_w ;
    key_x ;
    key_y ;
    key_z ;
    key_up ;
    key_down ;
    key_left ;
    key_right.

:- type window_event ---> quit_event ;
    unknown_event ;
    key_down(key) ;
    key_up(key) ;
    mouse_down(button, point) ;
    mouse_up(button, point) ;
    mouse_move(mouse_from::point, mouse_to::point).

%===============================================================================
%=== SDL2 Windowing for Mercury
%===============================================================================
:- import_module maybe.

:- type window_style ---> decorated ; borderless ; resizable ; fullscreen.

    % Creats a window
    % create_window(NewWindow, LocationAndSize, Title, Style, !IO)
:- pred create_window(window::uo, rect::in, string::in, window_style::in, io::di, io::uo) is det.
    % create_window(NewWindow, LocationAndSize, !IO)
:- pred create_window(window::uo, rect::in, io::di, io::uo) is det.

    % Frees a window
:- pred destroy_window(window::di, io::di, io::uo) is det.

:- pred window_surface(window::di, window::uo, surface::uo) is det.
:- pred window_update_surface(window::di, window::uo) is det.

:- func window_size(window::di, window::uo) = (size::uo) is det.
:- pred window_size(window, window, size).
:- mode window_size(di, uo, uo) is det.
:- mode window_size(di, uo, in) is det.

% Gets the next event. Will wait indefinitely for a new event to happen if none are queued
:- pred get_event(window::di, window::uo, window_event::out) is det.
:- func get_event(window::di, window::uo) = (window_event::out) is det.
% Retrieves the next event if one exists
:- pred check_event(window::di, window::uo, maybe(window_event)::out) is det.
:- func check_event(window::di, window::uo) = (maybe(window_event)::out) is det.
% Gets the next queued event if one exists. Otherwise, waits for a specified number of
%   milliseconds for a new event to occur
:- pred check_event(window::di, window::uo, int::in, maybe(window_event)::out) is det.
:- func check_event(window::di, window::uo, int::in) = (maybe(window_event)::out) is det.

%===============================================================================
%=== SDL2 Surfaces for Mercury
%===============================================================================

    % Constructs a surface
    % create_surface(NewSurface, Size, !IO)
:- pred create_surface(surface::uo, size::in, io::di, io::uo) is det.

:- pred destroy_surface(surface::di, io::di, io::uo) is det.

    % Sets or unsets RLE for a surface. Value of 0 is unset, value > 0 is set.
    % RLE-enabled surfaces blit and draw much faster, but must be locked before
    % being used with surface_pixel.
:- pred surface_rle(surface::di, surface::uo, int::in) is det.

    % Locks the pixels of a surface for use with surface_pixel.
:- pred surface_lock(surface::di, surface::uo) is det.

    % Unlocks the pixels of a surface after use with surface_pixel.
:- pred surface_unlock(surface::di, surface::uo) is det.

:- pred surface_size(surface::di, surface::uo, size::out) is det.

    % Gets/Sets the pixel format of a surface.
    % It is highly recommended that if you draw the same surface onto only one other
    % surface over and over again, you set the source surface's format to be the same as
    % the destination format.
    % This can be particularly pronounced when drawing backgrounds.
    % It is not a good idea to try to set the format of a window's surface.
:- pred surface_pixel_format(surface, surface, pixel_format).
:- mode surface_pixel_format(di, uo, out) is det.
:- mode surface_pixel_format(di, uo, in) is det.

:- pred surface_get_pixel_format(surface::di, surface::uo, pixel_format::out) is det.
:- pred surface_set_pixel_format(surface::di, surface::uo, pixel_format::in) is det.

    % Returns the native int value of a color based on a surface's format
    % map_color(!Surface, Color, Native)
:- pred map_color(surface, surface, color, int).
:- mode map_color(di, uo, in, out) is det.
:- mode map_color(di, uo, out, in) is det.

    % Returns the native int value of a color based on a pixel format
    % map_color(Format, Color, Native)
:- pred map_color(pixel_format, color, int).
:- mode map_color(in, in, out) is det.
:- mode map_color(in, out, in) is det.

    % Gets or sets the color of a pixel.
    % behaviour is undefined for points outside the size of the surface.
    % surface_pixel(!Surface, Color, Position)
:- pred surface_pixel(surface, surface, color, point).
:- mode surface_pixel(di, uo, in, in) is det.
:- mode surface_pixel(di, uo, out, in) is det.

    % Fills a region of a surface with a color.
    % surface_fill_rect(!Surface, Region, Color)
:- pred surface_fill_rect(surface::di, surface::uo, rect::in, color::in) is det.

    % Draws a surface onto another surface at a specific point
    % surface_blit_surface(!SourceSurface, SourceRegion, !DestinationSurface, DestinationRegion)
:- pred surface_blit_surface(surface::di, surface::uo, rect::in, surface::di, surface::uo, rect::in) is det.

    % Draws the entirety of a surface onto another surface at a specified point
    % surface_blit_surface(!SourceSurface, !DestinationSurface, DestinationOrigin)
:- pred surface_blit_surface(surface::di, surface::uo, surface::di, surface::uo, point::in) is det.

    % Non-destructively draws the entirety of a surface onto another surface at a specified point
    % surface_blit_surface(SourceSurface, !DestinationSurface, DestinationOrigin)
:- pred surface_blit_surface(surface::in, surface::di, surface::uo, point::in) is det.

    % Save
:- pred surface_bmp(surface::di, surface::uo, string::in, io::di, io::uo) is det.
    % Load
:- pred surface_bmp(io.read_result(surface)::uo, string::in, io::di, io::uo) is det.

%===============================================================================
%=== SDL2 Mouse support for Mercury
%===============================================================================

:- import_module io.
:- import_module bool.

:- type mouse_state ---> mouse_state(position::point, left_button::bool, middle_button::bool, right_button::bool).

:- pred mouse_position(io, io, point).
:- mode mouse_position(di, uo, out) is det.
:- mode mouse_position(di, uo, in) is det.

:- pred mouse_button(io::di, io::uo, mouse_state::uo) is det.

:- pred mouse_state_button(mouse_state::in, button::in) is semidet.
:- pred mouse_state_within(mouse_state::in, rect::in) is semidet.

%===============================================================================
%=== SDL2 Colors for Mercury
%===============================================================================

:- type color ---> color(r::int, g::int, b::int, a::int).

:- func blend(color, color) = (color).
:- mode blend(in, in) = (out) is det.

%===============================================================================
%=== Rect and Point manipulation
%===============================================================================

    % Equates to PointA + PointB = PointC
    % translate_point(PointA, PointB, PointC)
:- pred translate_point(point, point, point).
:- mode translate_point(in, in, out) is det.
:- mode translate_point(in, out, in) is det.
:- mode translate_point(out, in, in) is det.
:- mode translate_point(in, in, in) is semidet.

:- func translate_point(point, point) = (point).
:- mode translate_point(in, in) = (out) is det.
:- mode translate_point(in, out) = (in) is det.
:- mode translate_point(out, in) = (in) is det.

    % Equates to PointA - PointB = PointC
    % reverse_translate_point(PointA, PointB, PointC)
:- pred reverse_translate_point(point, point, point).
:- mode reverse_translate_point(in, in, out) is det.
:- mode reverse_translate_point(in, out, in) is det.
:- mode reverse_translate_point(out, in, in) is det.
:- mode reverse_translate_point(in, in, in) is semidet.

:- func reverse_translate_point(point, point) = (point).
:- mode reverse_translate_point(in, in) = (out) is det.
:- mode reverse_translate_point(in, out) = (in) is det.
:- mode reverse_translate_point(out, in) = (in) is det.

    % Equates to PointA * size(X, Y) = PointC
    % multiply_point(PointA, X, Y, PointC)
:- pred multiply_point(point, int, int, point).
:- mode multiply_point(in, in, in, out) is det.
:- mode multiply_point(in, in, in, in) is semidet.

:- func multiply_point(point, int, int) = (point).
:- mode multiply_point(in, in, in) = (out) is det.


%===============================================================================
:- implementation.
%===============================================================================

:- pragma foreign_decl("C", "#include <SDL2/SDL.h>").
:- pragma foreign_decl("C", "#include <stdio.h>").

%===============================================================================
%=== Rect, Point, and Size exports for C
%===============================================================================

:- func create_size(int::in, int::in) = (size::out) is det.
create_size(W, H) = (size(W, H)).
:- pragma foreign_export("C", create_size(in, in) = (out), "createSize").

:- pred get_size(size::in, int::out, int::out) is det.
get_size(size(W, H), W, H).
:- pragma foreign_export("C", get_size(in, out, out), "getSize").

:- func create_point(int::in, int::in) = (point::out) is det.
create_point(X, Y) = (point(X, Y)).
:- pragma foreign_export("C", create_point(in, in) = (out), "createPoint").

:- pred get_point(point::in, int::out, int::out) is det.
get_point(point(X, Y), X, Y).
:- pragma foreign_export("C", get_point(in, out, out), "getPoint").

:- func create_rect(int::in, int::in, int::in, int::in) = (rect::out) is det.
create_rect(X, Y, W, H) = (rect(point(X, Y), size(W, H))).
:- pragma foreign_export("C", create_rect(in, in, in, in) = (out), "createRect").

:- pred get_rect(rect::in, int::out, int::out, int::out, int::out) is det.
get_rect(rect(P, S), P ^ x, P ^ y, S ^ w,  S ^ h).
:- pragma foreign_export("C", get_rect(in, out, out, out, out), "getRect").

% Point manipulation

translate_point(point(X1, Y1), point(X2, Y2), point(X1 + X2, Y1 + Y2)).
translate_point(PointA, PointB) = (PointC) :- translate_point(PointA, PointB, PointC).

reverse_translate_point(point(X1, Y1), point(X2, Y2), point(X1 + X2, Y1 + Y2)).
reverse_translate_point(PointA, PointB) = (PointC) :- reverse_translate_point(PointA, PointB, PointC).

multiply_point(point(X, Y), W, H, point(X * W, Y * H)).
multiply_point(PointIn, X, Y) = (PointOut) :- multiply_point(PointIn, X, Y, PointOut).


% Colors

blend(color(R1, G1, B1, A1)::in, color(R - R1, G - G1, B - B1, A - A1)::in) = (color(R // 2, G // 2 , B // 2, A // 2)::out).

%===============================================================================
%=== Event Bridge for Mercury
%===============================================================================

:- pragma foreign_enum("C", key/0,
    [key_unknown - "SDLK_UNKNOWN",
    key_return - "SDLK_RETURN",
    key_escape - "SDLK_ESCAPE",
    key_backspace - "SDLK_BACKSPACE",
    key_tab - "SDLK_TAB",
    key_space - "SDLK_SPACE",
    key_exclamation - "SDLK_EXCLAIM",
    key_doublequote - "SDLK_QUOTEDBL",
    key_octothorp - "SDLK_HASH",
    key_percent - "SDLK_PERCENT",
    key_dollar - "SDLK_DOLLAR",
    key_ampersand - "SDLK_AMPERSAND",
    key_quote - "SDLK_QUOTE",
    key_openparen - "SDLK_LEFTPAREN",
    key_closeparen - "SDLK_RIGHTPAREN",
    key_asterisk - "SDLK_ASTERISK",
    key_plus - "SDLK_PLUS",
    key_minus - "SDLK_MINUS",
    key_comma - "SDLK_COMMA",
    key_period - "SDLK_PERIOD",
    key_slash - "SDLK_SLASH",
    key_zero - "SDLK_0",
    key_one - "SDLK_1",
    key_two - "SDLK_2",
    key_three - "SDLK_3",
    key_four - "SDLK_4",
    key_five - "SDLK_5",
    key_six - "SDLK_6",
    key_seven - "SDLK_7",
    key_eight - "SDLK_8",
    key_nine - "SDLK_9",
    key_semicolon - "SDLK_SEMICOLON",
    key_colon - "SDLK_COLON",
    key_lessthan - "SDLK_LESS",
    key_greaterthan - "SDLK_GREATER",
    key_question - "SDLK_QUESTION",
    key_openbracket - "SDLK_LEFTBRACKET",
    key_closebracket - "SDLK_RIGHTBRACKET",
    key_backslash - "SDLK_BACKSLASH",
    key_caret - "SDLK_CARET",
    key_underscore - "SDLK_UNDERSCORE",
    key_grave - "SDLK_BACKQUOTE",
    key_at - "SDLK_AT",
    key_a - "SDLK_a",
    key_b - "SDLK_b",
    key_c - "SDLK_c",
    key_d - "SDLK_d",
    key_e - "SDLK_e",
    key_f - "SDLK_f",
    key_g - "SDLK_g",
    key_h - "SDLK_h",
    key_i - "SDLK_i",
    key_j - "SDLK_j",
    key_k - "SDLK_k",
    key_l - "SDLK_l",
    key_m - "SDLK_m",
    key_n - "SDLK_n",
    key_o - "SDLK_o",
    key_p - "SDLK_p",
    key_q - "SDLK_q",
    key_r - "SDLK_r",
    key_s - "SDLK_s",
    key_t - "SDLK_t",
    key_u - "SDLK_u",
    key_v - "SDLK_v",
    key_w - "SDLK_w",
    key_x - "SDLK_x",
    key_y - "SDLK_y",
    key_z - "SDLK_z",
    key_up - "SDLK_UP",
    key_down - "SDLK_DOWN",
    key_left - "SDLK_LEFT",
    key_right - "SDLK_RIGHT"]).

:- func create_quit_event = (window_event::out) is det.
create_quit_event = (quit_event).
:- pragma foreign_export("C", create_quit_event = (out), "createQuit").

:- func create_unknown_event = (window_event::out) is det.
create_unknown_event = (unknown_event).
:- pragma foreign_export("C", create_unknown_event = (out), "createUnknown").

:- func create_key_down_event(key::in) = (window_event::out) is det.
create_key_down_event(Key) = (key_down(Key)).
:- pragma foreign_export("C", create_key_down_event(in) = (out), "createKeyDown").

:- func create_key_up_event(key::in) = (window_event::out) is det.
create_key_up_event(Key) = (key_up(Key)).
:- pragma foreign_export("C", create_key_up_event(in) = (out), "createKeyUp").

:- func create_mouse_down_event(button::in, int::in, int::in) = (window_event::out) is det.
create_mouse_down_event(Button, X, Y) = (mouse_down(Button, point(X, Y))).
:- pragma foreign_export("C", create_mouse_down_event(in, in, in) = (out), "createMouseDown").

:- func create_mouse_up_event(button::in, int::in, int::in) = (window_event::out) is det.
create_mouse_up_event(Button, X, Y) = (mouse_down(Button, point(X, Y))).
:- pragma foreign_export("C", create_mouse_up_event(in, in, in) = (out), "createMouseUp").

:- func create_no_event = (maybe(window_event)::out) is det.
create_no_event = (no).
:- pragma foreign_export("C", create_no_event = (out), "createNoEvent").

:- func create_yes_event(window_event::in) = (maybe(window_event)::out) is det.
create_yes_event(Event) = (yes(Event)).
:- pragma foreign_export("C", create_yes_event(in) = (out), "createYesEvent").

:- func create_mouse_move_event(int::in, int::in, int::in, int::in) = (window_event::out) is det.
create_mouse_move_event(FromX, FromY, ToX, ToY) = (mouse_move(point(FromX, FromY), point(ToX, ToY))).
:- pragma foreign_export("C", create_mouse_move_event(in, in, in, in) = (out), "createMouseMove").

:- pragma foreign_proc("C", get_event(WindowIn::di, WindowOut::uo) = (Event::out),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        SDL_Event e;
        SDL_WaitEvent(&e);
        switch(e.type){
            case SDL_QUIT: Event = createQuit(); break;
            case SDL_KEYDOWN: Event= createKeyDown(e.key.keysym.sym); break;
            default: Event = createUnknown(); break;
        }
        WindowOut = WindowIn;
    ").

get_event(WIn, WOut, get_event(WIn, WOut)).

:- pragma foreign_proc("C", check_event(WindowIn::di, WindowOut::uo) = (Event::out),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        SDL_Event e;
        if(SDL_PollEvent(&e)){
            switch(e.type){
                case SDL_QUIT: Event = createYesEvent(createQuit()); break;
                case SDL_KEYDOWN: Event = createYesEvent(createKeyDown(e.key.keysym.sym)); break;
                default: Event = createYesEvent(createUnknown()); break;
            }
        }
        else
            Event = createNoEvent();
        WindowOut = WindowIn;
    ").

check_event(WIn, WOut, check_event(WIn, WOut)).

% Gets the next queued event if one exists. Otherwise, waits for a specified number of
%   milliseconds for a new event to occur

:- pragma foreign_proc("C", check_event(WindowIn::di, WindowOut::uo, MS::in) = (Event::out),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        SDL_Event e;
        if(SDL_WaitEventTimeout(&e, MS)){
            switch(e.type){
                case SDL_QUIT: Event = createYesEvent(createQuit()); break;
                case SDL_KEYDOWN: Event = createYesEvent(createKeyDown(e.key.keysym.sym)); break;
                default: Event = createYesEvent(createUnknown()); break;
            }
        }
        else
            Event = createNoEvent();
        WindowOut = WindowIn;
    ").



check_event(WIn, WOut, MS, check_event(WIn, WOut, MS)).

%===============================================================================
%=== SDL2 Windowing for Mercury
%===============================================================================

:- pragma foreign_enum("C", window_style/0,
    [decorated - "0", 
     borderless - "SDL_WINDOW_BORDERLESS",
     resizable - "SDL_WINDOW_RESIZABLE",
     fullscreen - "SDL_WINDOW_FULLSCREEN"]).

create_window(Window, Rect, !IO) :- create_window(Window, Rect, "Mercury SDL2 Window", decorated, !IO).

:- pragma foreign_decl("C", "#define SDL_SUBSYSTEMS (SDL_INIT_VIDEO|SDL_INIT_TIMER)").

:- pragma foreign_type("C", window, "SDL_Window *").

:- pragma foreign_proc("C", create_window(Window::uo, Rect::in, Caption::in, Style::in, IOin::di, IOout::uo),
    [will_not_throw_exception, promise_pure],
    "
        MR_Integer x, y, w, h;
        int sub = SDL_WasInit(SDL_SUBSYSTEMS);
        getRect(Rect, &x, &y, &w, &h);
        
        if(!(sub & SDL_SUBSYSTEMS)){
/*            puts(\"Initializing SDL\"); */
            if(SDL_Init(SDL_INIT_VIDEO|SDL_INIT_TIMER|SDL_INIT_EVENTS)<0){
                puts(SDL_GetError());
            }
        }
        
        Window = SDL_CreateWindow(Caption, 
            x, y, w, h,
            (Style) | SDL_WINDOW_SHOWN|SDL_WINDOW_ALLOW_HIGHDPI);
        IOout = IOin;
    ").

:- pragma foreign_proc("C", destroy_window(Window::di, IOin::di, IOout::uo),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        SDL_DestroyWindow(Window);
        IOout = IOin;
    ").

:- pragma foreign_proc("C", window_surface(WindowIn::di, WindowOut::uo, Surface::uo),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        Surface = SDL_GetWindowSurface(WindowIn);
        WindowOut = WindowIn;
    ").

:- pragma foreign_proc("C", window_update_surface(WindowIn::di, WindowOut::uo),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        SDL_UpdateWindowSurface(WindowIn);
        WindowOut = WindowIn;
    ").

window_size(!Window) = (Rect) :- window_size(!Window, Rect).

:- pragma foreign_proc("C", window_size(WindowIn::di, WindowOut::uo, Size::uo),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        MR_Integer w, h; int iw, ih;
        SDL_GetWindowSize(WindowIn, &iw, &ih);
        w = iw; h = ih;
        Size = createSize(w, h);
        WindowOut = WindowIn;
    ").

:- pragma foreign_proc("C", window_size(WindowIn::di, WindowOut::uo, Size::in),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        MR_Integer w, h;
        getSize(Size, &w, &h);
        SDL_SetWindowSize(WindowIn, w, h);
        WindowOut = WindowIn;
    ").

%===============================================================================
%=== SDL2 Surfaces for Mercury
%===============================================================================

:- pragma foreign_decl("C", "#include <SDL2/SDL.h>").
:- pragma foreign_decl("C", "int rectIntersectsSurface(const SDL_Rect *rect, const SDL_Surface *surface);").
:- pragma foreign_type("C", surface, "SDL_Surface *").
:- pragma foreign_type("C", pixel_format, "SDL_PixelFormat *").

:- pragma foreign_code("C", 
    "
    int rectIntersectsSurface(const SDL_Rect *rect, const SDL_Surface *surface){
         return ((rect->w!=0) && (rect->h!=0) && 
            (rect->x<surface->w) && (rect->y<surface->h) && 
            (rect->x+rect->w>0) && (rect->y+rect->h>0));
    }
    "
).



%===============================================================================
%=== Functions for use to wrap surfaces, colors, and pixel formats from C 
%===============================================================================
:- pragma foreign_proc("C", surface_lock(SurfaceIn::di, SurfaceOut::uo),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        SDL_LockSurface(SurfaceIn);
        SurfaceOut = SurfaceIn;
    ").

:- pragma foreign_proc("C", surface_unlock(SurfaceIn::di, SurfaceOut::uo),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        SDL_UnlockSurface(SurfaceIn);
        SurfaceOut = SurfaceIn;
    ").

:- pragma foreign_proc("C", surface_rle(SurfaceIn::di, SurfaceOut::uo, RLE::in),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        SDL_SetSurfaceRLE(SurfaceIn, RLE);
        SurfaceOut = SurfaceIn;
    ").
    
:- pred get_color(color::in, int::out, int::out, int::out, int::out) is det.
get_color(color(R, G, B, A), R, G, B, A).
:- pragma foreign_export("C", get_color(in, out, out, out, out), "getColor").

:- func create_color(int::in, int::in, int::in, int::in) = (color::out) is det.
create_color(R, G, B, A) = (color(R, G, B, A)).
:- pragma foreign_export("C", create_color(in, in, in, in) = (out), "createColor").

%===============================================================================
%=== SDL2 Pixel Format Bridge
%===============================================================================
surface_get_pixel_format(!Surface, Format) :- surface_pixel_format(!Surface, Format).
surface_set_pixel_format(!Surface, Format) :- surface_pixel_format(!Surface, Format).

:- pragma foreign_proc("C", surface_pixel_format(SurfaceIn::di, SurfaceOut::uo, Format::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        Format = SurfaceIn->format;
        SurfaceOut = SurfaceIn;
    ").
   
:- pragma foreign_proc("C", surface_pixel_format(SurfaceIn::di, SurfaceOut::uo, Format::in),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        SurfaceOut = SDL_ConvertSurfaceFormat(SurfaceIn, Format->format, 0);
    ").

:- pragma foreign_proc("C", map_color(Format::in, Color::in, RGBA::out),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        MR_Integer r, g, b, a;
        getColor(Color, &r, &g, &b, &a);
        RGBA = SDL_MapRGBA(Format, r, g, b, a);
    ").

:- pragma foreign_proc("C", map_color(Format::in, Color::out, RGBA::in),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        Uint8 r, g, b, a;
        SDL_GetRGBA(RGBA, Format, &r, &g, &b, &a);
        Color = createColor(r, g, b, a);
    ").

map_color(!Surface, Color, RGBA) :-
    surface_pixel_format(!Surface, Format),
    map_color(Format, Color, RGBA).


%===============================================================================
%=== SDL2 Surface Bridge
%===============================================================================
:- pragma foreign_proc("C", create_surface(Surface::uo, Size::in, IOin::di, IOout::uo),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        MR_Integer w, h;
        getSize(Size, &w, &h);
        
        Surface = SDL_CreateRGBSurface(0, w, h, 32, 0, 0, 0, 0);
        SDL_SetSurfaceRLE(Surface, 1);
        
        IOout = IOin;
    ").

:- pragma foreign_proc("C", destroy_surface(Surface::di, IOin::di, IOout::uo),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        SDL_FreeSurface(Surface); 
        IOout = IOin;
    ").

:- pragma foreign_proc("C", surface_size(SurfaceIn::di, SurfaceOut::uo, Size::out),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        Size = createSize(SurfaceIn->w, SurfaceIn->h);
        SurfaceOut = SurfaceIn;
    ").

:- pragma foreign_proc("C", surface_pixel(SurfaceIn::di, SurfaceOut::uo, Color::in, Point::in),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        MR_Integer x, y, r, g, b, a;
        getPoint(Point, &x, &y);
        getColor(Color, &r, &g, &b, &a);
        
        if(x < SurfaceIn->w &&
            x >= 0 &&
            y < SurfaceIn->h &&
            y >= 0){


            ((Uint32 *)(SurfaceIn->pixels))[ (SurfaceIn->pitch * y) + x ] = SDL_MapRGBA(SurfaceIn->format, r, g, b, a);
        }

        SurfaceOut = SurfaceIn;
    ").

:- pragma foreign_proc("C", surface_pixel(SurfaceIn::di, SurfaceOut::uo, Color::out, Point::in),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        MR_Integer x, y;
        getPoint(Point, &x, &y);

        if(x < SurfaceIn->w &&
            x >= 0 &&
            y < SurfaceIn->h &&
            y >= 0){

            const Uint32 rgba = ((Uint32 *)(SurfaceIn->pixels))[ (SurfaceIn->pitch * y) + x ];
            Uint8 r, g, b, a;
            SDL_GetRGBA(rgba, SurfaceIn->format, &r, &g, &b, &a);
            Color = createColor(r, g, b, a);
        }
        else{
            Color = createColor(0, 0, 0, 0);
        }

        SurfaceOut = SurfaceIn;
    ").
% :- pred surface_fill_rect(surface::di, surface::uo, rect::in, color::in) is det.

:- pragma foreign_proc("C", surface_fill_rect(SurfaceIn::di, SurfaceOut::uo, Color::in, Rect::in),
    [will_not_throw_exception, promise_pure],
    "
        SDL_Rect rect;
        Uint32 color;

        {
            MR_Integer x, y, w, h;
            getRect(Rect, &x, &y, &w, &h);

            rect.x = x;
            rect.y = y;
            rect.w = w;
            rect.h = h;
        }
        if(rectIntersectsSurface(&rect, SurfaceIn)){
            {
                MR_Integer r, g, b, a;
                getColor(Color, &r, &g, &b, &a);

                color = SDL_MapRGBA(SurfaceIn->format, r, g, b, a);
            }

            SDL_FillRect(SurfaceIn, &rect, color);

            SurfaceOut = SurfaceIn;
        }
    ").
    % surface_blit_surface(!SourceSurface, SourceRegion, !DestinationSurface, DestinationRegion)
%:- pred surface_blit_surface(surface::di, surface::uo, rect::in, surface::di, surface::uo, rect::in) is det.

:- pragma foreign_proc("C", 
    surface_blit_surface(SourceSurfaceIn::di, SourceSurfaceOut::uo, SourceRect::in, 
        DestinationSurfaceIn::di, DestinationSurfaceOut::uo, DestinationRect::in),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        SDL_Rect src_rect, dst_rect;

        {
            MR_Integer x, y, w, h;
            getRect(SourceRect, &x, &y, &w, &h);
            src_rect.x = x;
            src_rect.y = y;
            src_rect.w = w;
            src_rect.h = h;

            getRect(DestinationRect, &x, &y, &w, &h);
            dst_rect.x = x;
            dst_rect.y = y;
            dst_rect.w = w;
            dst_rect.h = h;
        }
        
        if(rectIntersectsSurface(&src_rect, SourceSurfaceIn) && 
            rectIntersectsSurface(&dst_rect, DestinationSurfaceIn)){

            SDL_BlitSurface(SourceSurfaceIn, &src_rect, DestinationSurfaceIn, &dst_rect);
        }
        
        SourceSurfaceOut = SourceSurfaceIn;
        DestinationSurfaceOut = DestinationSurfaceIn;
    "
    ).

:- pragma foreign_proc("C", 
    surface_blit_surface(SourceSurfaceIn::di, SourceSurfaceOut::uo, 
        DestinationSurfaceIn::di, DestinationSurfaceOut::uo, Point::in),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        SDL_Rect rect;
        
        {
            MR_Integer x, y;
            getPoint(Point, &x, &y);
            rect.x = x;
            rect.y = y;
            rect.w = SourceSurfaceIn->w;
            rect.h = SourceSurfaceIn->h;
        }
        
        if(rectIntersectsSurface(&rect, DestinationSurfaceIn)){
            SDL_BlitSurface(SourceSurfaceIn, NULL, DestinationSurfaceIn, &rect);
        }

        SourceSurfaceOut = SourceSurfaceIn;
        DestinationSurfaceOut = DestinationSurfaceIn;
    ").

%:- pred surface_blit_surface(surface::in, surface::di, surface::uo, point::in) is det.
:- pragma foreign_proc("C", 
    surface_blit_surface(SourceSurface::in, DestinationSurfaceIn::di, DestinationSurfaceOut::uo, Point::in),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        SDL_Rect rect;
        
        {
            MR_Integer x, y;
            getPoint(Point, &x, &y);
            rect.x = x;
            rect.y = y;
            rect.w = SourceSurface->w;
            rect.h = SourceSurface->h;
        }
        
        if(rectIntersectsSurface(&rect, DestinationSurfaceIn)){
            SDL_BlitSurface(SourceSurface, NULL, DestinationSurfaceIn, &rect);
        }

        DestinationSurfaceOut = DestinationSurfaceIn;
    ").


%===============================================================================
%=== BMP functions 
%===============================================================================

% io.result(surface)::uo

% Silently fails.
:- pragma foreign_proc("C", 
    surface_bmp(SurfaceIn::di, SurfaceOut::uo, Path::in, IOin::di, IOout::uo),
    [will_not_throw_exception, promise_pure],
    "
        SDL_SaveBMP(SurfaceIn, Path);
        SurfaceOut = SurfaceIn;

        IOout = IOin;
    ").

:- func create_bmp_io_error(string::di, int::di) = (io.read_result(surface)::uo) is det.
create_bmp_io_error(Str::di, Int::di) = (io.error(Str, Int)::uo).
:- pragma foreign_export("C", create_bmp_io_error(di, di) = (uo), "createBMPIOError").

:- func create_bmp_io_ok(surface::di) = (io.read_result(surface)::uo) is det.
create_bmp_io_ok(Surface) = (ok(Surface)).
:- pragma foreign_export("C", create_bmp_io_ok(di) = (uo), "createBMPIOOk").

%:- pred surface_bmp(io.read_result(surface)::uo, string::in, io::di, io::uo) is det.
:- pragma foreign_proc("C", 
    surface_bmp(Result::uo, Path::in, IOin::di, IOout::uo),
    [will_not_throw_exception, promise_pure],
    "
        SDL_Surface * const surface = SDL_LoadBMP(Path);
        if(surface){
            Result = createBMPIOOk(surface);
        }
        else{
            MR_String str = (char *)SDL_GetError();
            Result = createBMPIOError(str, 0);
        }

        IOout = IOin;
    ").

%===============================================================================
%=== Mouse
%===============================================================================

:- import_module int.

mouse_state_button(State, Button) :-
    (
        Button = left,
        State ^ left_button = yes
    ;
        Button = right,
        State ^ right_button = yes
    ;
        Button = middle,
        State ^ middle_button = yes
    ).

mouse_state_within(mouse_state(point(Ox, Oy), _, _, _), rect(Origin, Size)) :-
    Ox >= Origin ^ x,
    Oy >= Origin ^ y,
    Ox =< Origin ^ x + Size ^ w,
    Oy =< Origin ^ y + Size ^ h.

:- pragma foreign_decl("C", "#include <SDL2/SDL.h>").

:- pragma foreign_enum("C", button/0,
    [left - "SDL_BUTTON_LEFT", 
     middle - "SDL_BUTTON_MIDDLE",
     right - "SDL_BUTTON_RIGHT"]).

:- func create_mouse_state(point::in, bool::in, bool::in, bool::in) = (mouse_state::out) is det.
create_mouse_state(Point, L, M, R) = (mouse_state(Point, L, M, R)).
:- pragma foreign_export("C", create_mouse_state(in, in, in, in) = (out), "createMouseState").

:- pragma foreign_proc("C", mouse_position(IOin::di, IOout::uo, Point::out),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        int x, y;
        SDL_GetRelativeMouseState(&x, &y);
        Point = createPoint(x, y);
        IOout = IOin;
    ").

:- pragma foreign_proc("C", mouse_position(IOin::di, IOout::uo, Point::in),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        SDL_Window * const window = SDL_GetMouseFocus();
        if(window){
            MR_Integer x, y;
            getPoint(Point, &x, &y);
            SDL_WarpMouseInWindow(window, x, y);
        }
        IOout = IOin;
    ").

:- pragma foreign_proc("C", mouse_button(IOin::di, IOout::uo, State::uo),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        {
            int x, y;
            const Uint32 state = SDL_GetRelativeMouseState(&x, &y);

            const MR_Bool l = ((state & SDL_BUTTON_LEFT) ? MR_YES : MR_NO),
                m = ((state & SDL_BUTTON_MIDDLE) ? MR_YES : MR_NO),
                r = ((state & SDL_BUTTON_RIGHT) ? MR_YES : MR_NO);

            State = createMouseState(createPoint(x, y), l, m, r);
        }
        IOout = IOin;
    ").
