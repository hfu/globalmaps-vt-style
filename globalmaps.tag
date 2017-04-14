  <globalmaps>
    <ul>
      <globalmap each={ countries } id={ id } country={ country } version={ version } issues={ issues }></globalmap>
    </ul>
    <script>
      this.countries = [{"id":"gmaf20vt","country":"Afghanistan","version":2.0,"issues":"loading"},{"id":"gmal20vt","country":"Albania","version":2.0,"issues":"loading"}]
    </script>
  </globalmaps>

  <globalmap>
    <li id='{ id }'><input type='checkbox'/><a title='open in the right frame' target='right' href='{ id }.html'>{ country } { version }</a> { issues }</li>
    <script>
      var self = this
      fetch('https://api.github.com/repos/globalmaps-vt/' + self.id + '/issues?access_token=8b43c94857c0b73158c0168e09d64a1618557806').then(function(data){return data.json()}).then(function(json) {self.issues = json.length + ' issues'; self.update()})
    </script>
  </globalmap>
