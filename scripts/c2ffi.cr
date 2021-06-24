Dir.cd(__DIR__) do
  system "c2ffi ../gr/lib/gr/gr.h   > gr.json"
  system "c2ffi ../gr/lib/gr3/gr3.h > gr3.json"
  system "c2ffi ../gr/lib/grm/grm.h > grm.json"
end
