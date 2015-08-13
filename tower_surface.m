:- module tower_surface.
:- interface.

%===============================================================================
%=== SDL2 Surfaces for Mercury
%===============================================================================

:- import_module tower_rect.
:- import_module io.

:- type surface.
:- type pixel_format.

    % Constructs a surface
    % create_surface(NewSurface, Size, !IO)
:- pred create_surface(surface::uo, size::in, io::di, io::uo) is det.

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
:- pred surface_pixel_format(surface, surface, pixel_format) is det.
:- mode surface_pixel_format(di, uo, out) is det.
:- mode surface_pixel_format(di, uo, in) is det.

:- pred surface_get_pixel_format(surface::di, surface::uo, pixel_format::out) is det.
:- pred surface_set_pixel_format(surface::di, surface::uo, pixel_format::in) is det.

:- type color ---> color(r::int, g::int, b::int, a::int).

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

    % Save
:- pred surface_bmp(surface::di, surface::uo, string::in, io::di, io::uo) is det.
    % Load
:- pred surface_bmp(io.read_result(surface)::uo, string::in, io::di, io::uo) is det.

%===============================================================================
:- implementation.
%===============================================================================

:- pragma foreign_decl("C", "#include <SDL2/SDL.h>").
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
    [will_not_throw_exception, promise_pure, thread_safe],
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
            Result = createBMPIOError(SDL_GetError(), 0);
        }

        IOout = IOin;
    ").
