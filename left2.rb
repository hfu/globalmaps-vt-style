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
      :version => v['version']
    }
  }
  w.print <<-EOS
  <globalmaps>
    <ul>
      <li each={ countries }><input type='checkbox'/><a title='open in the right frame' target='right' href='{ id }.html'>{ country } { version }</a></li>
    </ul>
    <script>
      this.countries = #{JSON::dump(countries)}
    </script>
  </globalmaps>
  EOS
}
