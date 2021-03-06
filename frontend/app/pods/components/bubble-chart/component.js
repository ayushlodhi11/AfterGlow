import Ember from 'ember';
import UtilsFunctions from 'frontend/mixins/utils-functions';

var get = Ember.get,
    arrayComputed = Ember.arrayComputed;
export default Ember.Component.extend(UtilsFunctions, {

    didInsertElement() {
        this.get('getData')(this);
    },
    data: Ember.observer('jsonData', 'type', 'xLabel', 'yLable', 'title', function () {
        Ember.run.next(this, function () {
            this.get('getData')(this);
        });
    }),

    defaultChartType: 'Bubble',
    getData(_this) {}
});
