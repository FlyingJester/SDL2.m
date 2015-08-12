:- module tower_rect.
:- interface.

:- type size ---> size(w::int, h::int).
:- type point ---> point(x::int, y::int).
:- type rect ---> rect(origin::point, size).

:- implementation.

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
