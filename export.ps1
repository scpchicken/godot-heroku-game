godot_v3.2.2 --export "HTML5" linux/html/deez.html
godot_v3.2.2 --export-pack "Linux/X11" linux/fast.pck

cd linux
heroku container:login
heroku container:push web --app thisissodumb
heroku container:release web --app thisissodumb
heroku open -a thisissodumb

