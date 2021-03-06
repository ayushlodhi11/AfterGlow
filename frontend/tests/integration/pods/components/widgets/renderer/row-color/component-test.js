import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('widgets/renderer/row-color', 'Integration | Component | widgets/renderer/row color', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{widgets/renderer/row-color}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#widgets/renderer/row-color}}
      template block text
    {{/widgets/renderer/row-color}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
