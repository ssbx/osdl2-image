open Osdl2
open Osdl2_image

let () =
  let width, height = (320, 240) in
  Sdl.init [`VIDEO];
  SdlImage.init [`PNG];

  let window =
    Sdl.Window.create
      ~title:"Osdl Image loaded as Surface"
      ~dims:(width, height)
      ~pos:(`undefined, `undefined)
      ~flags:[]
  in
  let screen = Sdl.Window.get_surface window in

  let finish () =
    Sdl.quit ();
    SdlImage.quit ();
    print_endline "DONE!";
    exit 0
  in

  let filename = "../imgs/caml_icon.png" in
  let rw = Sdl.RWops.from_file ~filename ~mode:"rb" in
  let surf = SdlImage.load_png_rw rw in

  let surf_dims = Sdl.Surface.get_dims surf in
  let surf_pos = (128, 64) in

  let screen_rect = Sdl.Rect.make4 ~x:0 ~y:0 ~w:width ~h:height in
  let src_rect = Sdl.Rect.make4 ~x:0 ~y:0 ~w:width ~h:height in
  let dst_rect = Sdl.Rect.make ~pos:surf_pos ~dims:surf_dims in

  let render x =
    Sdl.Surface.fill_rect
      ~color:0x00_00_00l
      ~dst:screen
      ~rect:screen_rect;

    if x = width then finish ();
    let dst_rect = { dst_rect with Sdl.Rect.x } in
    let _ =
      Sdl.Surface.blit_surface
        ~src:surf ~dst:screen
        ~src_rect ~dst_rect
    in
    Sdl.Window.update_surface window;
  in

  let rec main_loop x =
    render x;
    Sdl.Timer.delay ~ms:10;
    main_loop (x + 1)
  in
  main_loop 0
