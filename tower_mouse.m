:- module tower_mouse.
:- interface.

%===============================================================================
%=== SDL2 Mouse support for Mercury
%===============================================================================

:- import_module io.
:- import_module bool.
:- import_module tower_rect.

:- type button ---> left ; middle ; right.
:- type mouse_state ---> mouse_state(position::point, left_button::bool, middle_button::bool, right_button::bool).

:- pred mouse_position(io, io, point).
:- mode mouse_position(di, uo, out) is det.
:- mode mouse_position(di, uo, in) is det.

:- pred mouse_button(io::di, io::uo, mouse_state::uo) is det.

:- pred mouse_state_button(mouse_state::in, button::in) is semidet.
:- pred mouse_state_within(mouse_state::in, rect::in) is semidet.

%===============================================================================
:- implementation.
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
