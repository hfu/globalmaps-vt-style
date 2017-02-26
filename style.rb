require 'json'

template = {
  :version => 8,
  :name => 'Global Map vector tiles',
  :glyphs => 'https://smellman.github.io/creating_tiles_with_global_map_support_files/2015/mapbox_vector_tile_demo/demosites/fonts/{fontstack}/{range}.pbf',
  :sources => {
    :gmjp22vt => {
      :type => 'vector',
      :tiles => ['https://globalmaps-vt.github.io/gmjp22vt/{z}/{x}/{y}.mvt'],
      :minzoom => 0,
      :maxzoom => 8,
      :attribution => 'Geospatial Information Authority of Japan'
    }
  },
  :layers => [
    {
      :id => :gmjp22vt,
      :type => :line,
      :source => :gmjp22vt,
      'source-layer' => :BA010,
      :minzoom => 0,
      :maxzoom => 20,
      :layout => {
        'line-join' => :round,
        'line-cap' => :round
      },
      :paint => {
        'line-color': '#bbbbbb',
        'line-width': 1
      }
    }
  ]
}

print JSON::dump(template)
