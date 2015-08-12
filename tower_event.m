:- module tower_event.
:- interface.

%===============================================================================
%=== SDL2 Events for Mercury
%===============================================================================

:- import_module io.
:- import_module tower_rect.

:- type button ---> left ; middle ; right.

:- type tower_event ---> other_event
  ; time_event
  ; quit_event
  ; button_release_event(point, button)
  ; button_press_event(point, button).

:- pred get_event(tower_event::uo, io::di, io::uo) is det.

%===============================================================================
:- implementation.
%===============================================================================

:- import_module bool.

:- pragma foreign_decl("C", "#include <SDL2/SDL.h>").

:- pragma foreign_enum("C", button/0,
    [left - "SDL_BUTTON_LEFT", 
     middle - "SDL_BUTTON_MIDDLE",
     right - "SDL_BUTTON_RIGHT"]).

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
create_button_release_event(X, Y, Button) = (button_press_event(point(X, Y), Button)).
:- pragma foreign_export("C", create_button_release_event(in, in, in) = (out), "createButtonReleaseEvent").

%===============================================================================
%=== SDL2 Event Bridge
%===============================================================================
:- pragma foreign_proc("C", get_event(Event::uo, IOin::di, IOout::uo),
    [promise_pure, thread_safe],
    "
        SDL_Event e;
        if(SDL_WaitEventTimeout(&e, 16)==0){
            Event = createTimeEvent();
        }
        else if(e.type==SDL_QUIT){
            Event = createQuitEvent();
        }
        else if(e.type==SDL_MOUSEBUTTONDOWN){
            if(e.button.button!=SDL_BUTTON_LEFT && 
                e.button.button!=SDL_BUTTON_LEFT && 
                e.button.button!=SDL_BUTTON_LEFT)
                Event = createOtherEvent();
            else
                Event = createButtonPressEvent(e.button.x, e.button.y, e.button.button);
        }
        else if(e.type==SDL_MOUSEBUTTONUP){
            if(e.button.button!=SDL_BUTTON_LEFT && 
                e.button.button!=SDL_BUTTON_LEFT && 
                e.button.button!=SDL_BUTTON_LEFT)
                Event = createOtherEvent();
            else
                Event = createButtonReleaseEvent(e.button.x, e.button.y, e.button.button);
        }
        else
            Event = createOtherEvent();
        IOout = IOin;
    ").
