:- module color.
:- interface.

:- type color ---> color(r::int, g::int, b::int, a::int).

:- pred color.blend(color, color, color).
:- mode color.blend(in, in, out) is det.
:- mode color.blend(in, out, in) is det.
:- mode color.blend(out, in, in) is det.
:- mode color.blend(in, in, in) is semidet.

%===============================================================================
:- implementation.
%===============================================================================

:- func average(int, int) = (int).
:- mode average(in, in) = (out) is det.
:- mode average(in, out) = (in) is det.
:- mode average(out, in) = (in) is det.
:- mode average(in, in) = (in) is semidet.

:- func halve(int) = (int).
:- mode halve(in) = (out) is det.
:- mode halve(out) = (in) is det.
:- mode halve(in) = (in) is semidet.

:- import_module int.

halve(A::in) = (B::out) :-
    A // 2 = B.

halve(A::out) = (B::in) :-
    B * 2 = A.

halve(A::in) = (B::in) :-
    A // 2 = B.

average(A, B) = (A + B).

color.blend(color(R1, G1, B1, A1), color(R2, G2, B2, A2), color(average(R1, R2), average(G1, G2), average(B1, B2), average(A1, A2))).
