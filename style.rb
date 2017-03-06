require 'json'

def create(params)
  template = {
    :version => 8,
    :name => 'Global Map vector tiles',
    :glyphs => 'https://smellman.github.io/creating_tiles_with_global_map_support_files/2015/mapbox_vector_tile_demo/demosites/fonts/{fontstack}/{range}.pbf',
    :sources => {
      params['id'] => {
        :type => 'vector',
        :tiles => ["https://globalmaps-vt.github.io/#{params['id']}/{z}/{x}/{y}.mvt"],
        :minzoom => 0,
        :maxzoom => 8,
        :attribution => "Global Map #{params['country']} #{params['version']} by #{params['ngia']}"
      }
    },
    :layers => [
      {
        :id => 'background',
        :type => 'background',
        :paint => {
          'background-color' => '#eef'
        }
      }
    ]
  }
  [ # re-ordered for drawing
    %w{XX501 #ff0 0.1}, # landmask area
    %w{BA030 #e3f3f7 0.5}, # island
    %w{BA020 #e3f3f7 0.5}, # foreshore
    %w{FA001 #faf7ef 0.5}, # administrative area
    %w{BA040 #e3f3f7 0.8}, # water
    %w{BH000 #5494a8 0.8}, # inland water
    %w{BH080 #e3f3f7 0.8}, # lake / pond
    %w{BH130 #e3f3f7 0.8}, # reservoir
    %w{BJ030 #ccf 0.5}, # glacier
    %w{BJ100 #ccf 0.5}, # snow field
    %w{AL020 #ffc300 0.8}, # builtup area
  ].each {|r|
    template[:layers] << {
      'id' => "pg#{r[0]}",
      'type' => 'fill',
      'source' => params['id'],
      'source-layer' => "pg#{r[0]}",
      'paint' => {
        'fill-color' => r[1],
        'fill-opacity' => r[2].to_f
      }
    }
  }
  [
    %w{AN010 #000 1}, # railway
    %w{AN500 #e7b2a8 2}, # raliway network link
    %w{AP030 #ccc 1}, # road
    %w{AP050 #ccc 1}, # trail
    %w{AP500 #ccc 1}, # road network link
    %w{AQ040 #f00 2}, # bridge
    %w{AQ070 #5494a8 1}, # ferry route
    %w{AQ130 #f00 2}, # tunnel
    %w{BA010 #5494a8 1}, # coastline
    %w{BH140 #54a498 1}, # river
    %w{BH210 #5494a8 1}, # inland shoreline
    %w{BH502 #5494a8 1}, # watercourse
    %w{BI020 #aaf 2}, # dam
    %w{BI030 #aaf 2}, # lock
    %w{FA000 #f00 1}, # administrative boundary
    %w{XX500 #00f 1} # sea limit
  ].each {|r|
    template[:layers] << {
      :id => "ls#{r[0]}",
      :type => :line,
      :source => params['id'],
      'source-layer' => "ls#{r[0]}",
      :minzoom => 0,
      :maxzoom => 20,
      :layout => {
        'line-join' => :round,
        'line-cap' => :round
      },
      :paint => {
        'line-color' => r[1],
        'line-width' => r[2].to_i,
        'line-opacity' => 0.5
      }
    }
  }
  [
    %w{AL020 nam #bbb}, # builtup area
    %w{AL105 nam #bbb}, # settlement
    %w{AN060}, # railroad yard
    %w{AP020}, # interchange
    %w{AQ062}, # crossing
    %w{AQ063}, # road intersection
    %w{AQ080 nam #bbb}, # ferry site
    %w{AQ090}, # entrance / exit
    %w{AQ125 nam #bbb}, # station
    %w{AQ135}, # vehicle stopping area
    %w{BH170}, # spring
    %w{BH503}, # hydrographic network node
    %w{BI029}, # dam
    %w{BI030}, # lock
    %w{GB005 nam #bbb}, # airport
    %w{ZD040 namn1 #bbb} # named location
  ].each {|r|
    template[:layers] << {
      'id' => "pt#{r[0]}",
      'type' => 'symbol',
      'source' => params['id'],
      'source-layer' => "pt#{r[0]}",
      'paint' => {
        'text-color' => r[2] ? r[2] : '#bbb',
      },
      'layout' => {
        'text-field' => r[1] ? '{' + r[1] + '}' : '*',
        'text-size' => 12
      }
    }
  }
  File.write("#{params['id']}.json", JSON::dump(template))
  File.open("#{params['id']}.html", 'w') {|w|
    w.print <<-EOS
<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8' />
<title>Binary vector tiles</title>
<meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
<script src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.32.1/mapbox-gl.js'></script>
<link href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.32.1/mapbox-gl.css' rel='stylesheet' />
<link href='https://www.mapbox.com/base/latest/base.css' rel='stylesheet' />
<style>
body { margin:0; padding:0; }
#map { position:absolute; top:0; bottom:0; width:100%; }
.map-overlay {
  z-index: 20;
  font: 12px/20px sans-serif;
  position: absolute; width: 40%; top: 0; left: 0; padding: 10px
}
.map-overlay .map-overlay-inner {
  background-color: #fff; border-radius: 3px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
  padding: 10px; margin-bottom: 10px;
}
</style>
</head>
<body>
<div class='map-overlay top'>
  <div class='map-overlay-inner'>
    Global Map #{params['country']} #{params['version']}<br/>
    <a title='open in another tab' target='_blank' href='#{params['id']}.html'>new tab</a>/<a title='open issues (vt)' target='_blank'  href='http://github.com/globalmaps-vt/#{params['id']}/issues'>issues</a>/<a title='download Shapefile data from the Global Map Archives' target='_blank' href='http://github.com/globalmaps/#{params['id'].sub(/vt$/, '')}/archive/master.zip'>zip</a>
  </div>
</div>
<div id='map'></div>
<script>
map = new mapboxgl.Map({
  container: 'map', style: '#{params['id']}.json',
  center: #{params['center'][0..1].to_s}, zoom: #{params['center'][2]}, hash: true, maxZoom: 19
});
</script>
</body>
</html>
    EOS
  }
end

File.open('left.html', 'w') {|w|
  w.print <<-EOS
<!doctype html>
<html>
<head>
<style>
body {
  //background-color: #3f4347;
  font: 12px/20px sans-serif;
}
a:link {color: #0062d9;}
a:visited {color: #0062d9;}
ul {margin: 0; padding: 0; list-style: none; float: left;}
</style>
</head>
<body><h2 style="color: #0ff"><a target="_blank"  href="https://github.com/hfu/globalmaps-vt-style/">QC Global Maps</a></h2><ul>
  EOS
  JSON::parse(File.read('list.json'))['list'].each {|r|
    create(r)
    w.print "<li><input type='checkbox'/><a title='open in the right frame' target='right' href='#{r['id']}.html'>#{r['country']} #{r['version']}</a></li>\n"
  }
  w.print <<-EOS
</ul></body>
</html>
  EOS
}
