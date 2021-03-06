import Ember from 'ember';

export default Ember.Component.extend({

    filteredColumns: Ember.computed('columns', 'columnQuery', function () {
        let columns = this.get('columns');
        let columnQuery = this.get('columnQuery');
        if (columns && columnQuery) {
            return columns.filter(function (item) {
                return item.get('human_name') && item.get('human_name').toLowerCase().match(columnQuery.toLowerCase());
            });
        } else {
            return columns;
        }
    }),
    labelObserver: Ember.on('init', Ember.observer('orderBy.column', 'orderBy.order', function () {
        let orderBy = this.get('orderBy');
        if (orderBy) {
            orderBy = Ember.Object.create(orderBy);
            let label = (orderBy.get('column.human_name') || orderBy.get('column.name') || orderBy.get('column.value'));
            this.get('orderBy.column') && (label += ' : ' + this.get('orderBy.order.name'));
            orderBy.set('label', label);
        }
    })),


    orders: [{

        name: 'Asending',
        value: 'ASC'
    },
    {

        name: 'Desending',
        value: 'DESC'
    },

    ],

});
