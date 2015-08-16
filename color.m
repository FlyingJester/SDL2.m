:- module color.
:- interface.

:- type color ---> color(r::int, g::int, b::int, a::int).

:- func color.blend(color, color) = (color).
:- mode color.blend(in, in) = (out) is det.

%===============================================================================
:- implementation.
%===============================================================================

:- import_module int.

color.blend(color(R1, G1, B1, A1)::in, color(R - R1, G - G1, B - B1, A - A1)::in) = (color(R // 2, G // 2 , B // 2, A // 2)::out).

