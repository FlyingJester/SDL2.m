:- module tower_event.
:- interface.

%===============================================================================
%=== SDL2 Events for Mercury
%===============================================================================

:- import_module io.
:- import_module tower_rect.
:- import_module tower_mouse.

:- type tower_event ---> other_event
  ; time_event
  ; quit_event
  ; button_release_event(point, button)
  ; mouse_motion_event(point, size)
  ; button_press_event(point, button).

:- pred get_event(tower_event::uo, io::di, io::uo) is det.

%===============================================================================
:- implementation.
%===============================================================================

:- import_module bool.

:- pragma foreign_decl("C", "#include <SDL2/SDL.h>").

%===============================================================================
%=== Functions for use to wrap events from C 
%===============================================================================
:- func create_quit_event = (tower_event::out) is det.
create_quit_event = (quit_event).
:- pragma foreign_export("C", create_quit_event = (out), "createQuitEvent").

:- func create_other_event = (tower_event::out) is det.
create_other_event = (other_event).
:- pragma foreign_export("C", create_other_event = (out), "createOtherEvent").

:- func create_time_event = (tower_event::out) is det.
create_time_event = (time_event).
:- pragma foreign_export("C", create_time_event = (out), "createTimeEvent").

:- func create_button_press_event(int::in, int::in, button::in) = (tower_event::out) is det.
create_button_press_event(X, Y, Button) = (button_press_event(point(X, Y), Button)).
:- pragma foreign_export("C", create_button_press_event(in, in, in) = (out), "createButtonPressEvent").

:- func create_button_release_event(int::in, int::in, button::in) = (tower_event::out) is det.
create_button_release_event(X, Y, Button) = (button_release_event(point(X, Y), Button)).
:- pragma foreign_export("C", create_button_release_event(in, in, in) = (out), "createButtonReleaseEvent").

:- func create_mouse_motion_event(int::in, int::in, int::in, int::in) = (tower_event::out) is det.
create_mouse_motion_event(X, Y, DX, DY) = (mouse_motion_event(point(X, Y), size(DX, DY))).
:- pragma foreign_export("C", create_mouse_motion_event(in, in, in, in) = (out), "createMouseMotionEvent").

%===============================================================================
%=== SDL2 Event Bridge
%===============================================================================
:- pragma foreign_proc("C", get_event(Event::uo, IOin::di, IOout::uo),
    [will_not_throw_exception, promise_pure, thread_safe],
    "
        SDL_Event e;
        if(SDL_WaitEventTimeout(&e, 32)==0){
            Event = createTimeEvent();
        }
        else if(e.type==SDL_QUIT){
            Event = createQuitEvent();
        }
        else if(e.type==SDL_MOUSEBUTTONDOWN){
            if(e.button.button!=SDL_BUTTON_LEFT && 
                e.button.button!=SDL_BUTTON_MIDDLE && 
                e.button.button!=SDL_BUTTON_RIGHT)
                Event = createOtherEvent();
            else
                Event = createButtonPressEvent(e.button.x, e.button.y, e.button.button);
        }
        else if(e.type==SDL_MOUSEBUTTONUP){
            if(e.button.button!=SDL_BUTTON_LEFT && 
                e.button.button!=SDL_BUTTON_MIDDLE && 
                e.button.button!=SDL_BUTTON_RIGHT)
                Event = createOtherEvent();
            else
                Event = createButtonReleaseEvent(e.button.x, e.button.y, e.button.button);
        }
        else if(e.type==SDL_MOUSEMOTION){
            Event = createMouseMotionEvent(e.motion.x, e.motion.y, e.motion.xrel, e.motion.yrel);
        }
        else
            Event = createOtherEvent();
        IOout = IOin;
    ").
