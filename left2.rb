require 'json'

File.open('left2.html', 'w') {|w|
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
<body><h2 style="color: #0ff"><a target="_blank"  href="https://github.com/hfu/globalmaps-vt-style/">QC Global Maps</a></h2>
<globalmaps></globalmaps>
<script type="riot/tag" src="globalmaps.tag"></script>
<script src="https://cdn.jsdelivr.net/riot/3.2/riot+compiler.min.js"></script>
<script>riot.mount('globalmaps')</script>
</body>
</html>
  EOS
}

File.open('globalmaps.tag', 'w') {|w|
  countries = JSON::parse(File.read('list.json'))['list'].map{|v|
    {
      :id => v['id'],
      :country => v['country'],
      :version => v['version'],
      :issues => 'loading'
    }
  }
  w.print <<-EOS
  <globalmaps>
    <ul>
      <globalmap each={ countries } id={ id } country={ country } version={ version } issues={ issues }></globalmap>
    </ul>
    <script>
      this.countries = #{JSON::dump(countries)}
    </script>
  </globalmaps>

  <globalmap>
    <li id='{ id }'><input type='checkbox'/><a title='open in the right frame' target='right' href='{ id }.html'>{ country } { version }</a> { issues }</li>
    <script>
      var self = this
      fetch('https://api.github.com/repos/globalmaps-vt/' + self.id + '/issues?access_token=8b43c94857c0b73158c0168e09d64a1618557806').then(function(data){return data.json()}).then(function(json) {self.issues = json.length + ' issues'; self.update()})
    </script>
  </globalmap>
  EOS
}
