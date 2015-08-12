:- module tower_window.
:- interface.

%===============================================================================
%=== SDL2 Windowing for Mercury
%===============================================================================

:- import_module io.
:- import_module tower_rect.
:- import_module tower_surface.

:- type window.

:- pred create_window(window::uo, rect::in, string::in, io::di, io::uo) is det.
:- pred create_window(window::uo, int::in, int::in, string::in, io::di, io::uo) is det.
:- pred create_window(window::uo, rect::in, io::di, io::uo) is det.
:- pred destroy_window(window::di, io::di, io::uo) is det.

:- func window_surface(window::di, window::uo) = (surface::out) is det.
:- pred window_update_surface(window::di, window::uo) is det.

:- func window_size(window::di, window::uo) = (size::uo) is det.
:- pred window_size(window, window, size) is det.
:- mode window_size(di, uo, uo) is det.
:- mode window_size(di, uo, in) is det.

%===============================================================================
:- implementation.
%===============================================================================

create_window(Window, W, H, Caption, !IO) :- create_window(Window, rect(point(0, 0), size(W, H)), Caption, !IO).
create_window(Window, Rect, !IO) :- create_window(Window, Rect, "Mercury SDL2 Window", !IO).

:- pragma foreign_decl("C", "#include <SDL2/SDL.h>").
:- pragma foreign_decl("C", "#include <stdio.h>").
:- pragma foreign_decl("C", "#define SDL_SUBSYSTEMS (SDL_INIT_VIDEO|SDL_INIT_TIMER)").

:- pragma foreign_type("C", window, "SDL_Window *").

:- pragma foreign_proc("C", create_window(Window::uo, Rect::in, Caption::in, IOin::di, IOout::uo),
    [promise_pure, thread_safe],
    "
        MR_Integer x, y, w, h,
            sub = SDL_WasInit(SDL_SUBSYSTEMS);
        getRect(Rect, &x, &y, &w, &h);
        
        if(!sub & SDL_SUBSYSTEMS){
            puts(\"Initializing SDL\");
            if(SDL_Init(SDL_INIT_VIDEO|SDL_INIT_TIMER)<0){
                puts(SDL_GetError());
            }
        }
        
        Window = SDL_CreateWindow(Caption, 
            x, y, w, h,
            SDL_WINDOW_SHOWN|SDL_WINDOW_ALLOW_HIGHDPI);
        IOout = IOin;
    ").

:- pragma foreign_proc("C", destroy_window(Window::di, IOin::di, IOout::uo),
    [promise_pure, thread_safe],
    "
        SDL_DestroyWindow(Window);
        IOout = IOin;
    ").

:- pragma foreign_proc("C", window_surface(WindowIn::di, WindowOut::uo) = (Surface::out),
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
    [promise_pure, thread_safe],
    "
        MR_Integer w, h;
        SDL_GetWindowSize(WindowIn, &w, &h);
        Size = createSize(w, h);
        WindowOut = WindowIn;
    ").

:- pragma foreign_proc("C", window_size(WindowIn::di, WindowOut::uo, Size::in),
    [promise_pure, thread_safe],
    "
        MR_Integer w, h;
        getSize(Size, &w, &h);
        SDL_SetWindowSize(WindowIn, w, h);
        WindowOut = WindowIn;
    ").
