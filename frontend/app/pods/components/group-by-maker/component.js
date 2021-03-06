import Ember from 'ember';

export default Ember.Component.extend({
    selectedGroupBy: Ember.computed('groupBy.selected', 'columns', function () {
        let selected = this.get('groupBy.selected');
        let columns = this.get('columns');
        if (selected && columns) {
            return this.get('columns').findBy(
                'human_name',
                Ember.Object.create(selected).get('human_name')
            );
        }
    }),

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
    labelObserver: Ember.on('init', Ember.observer('groupBy.selected', 'groupBy.castType', 'groupBy.selected.value', function () {
        let groupBy = this.get('groupBy');
        if (groupBy) {
            groupBy = Ember.Object.create(groupBy);
            if (groupBy.get('selected.raw') == true) {
                groupBy.set('selected.human_name', null);
                groupBy.set('selected.name', null);
            }
            let label = (groupBy.get('selected.human_name') || groupBy.get('selected.name') || groupBy.get('selected.value'));
            if (this.get('isGroupByDateType')) {
                label = label + ': ' + groupBy.get('castType.name');
            } else {
                this.set('caseType', null);
            }
            groupBy.set('label', label);
        }
    })),

    isGroupByDateType: Ember.computed('groupBy.selected', function () {
        let dataType = this.get('groupBy.selected.data_type');
        if ((dataType == 'date') || (dataType == 'datetime') || (dataType == 'timestamp without time zone') || dataType == 'timestamp') {
            return true;
        } else {
            return false;
        }

    }),

    groupByDateTypes: [{
        name: 'As It is',
        value: null
    },
    {
        name: 'by Seconds',
        value: 'seconds'
    },
    {
        name: 'by Minute',
        value: 'minutes'
    },
    {
        name: 'by Day',
        value: 'day'
    },
    {
        name: 'by Hour',
        value: 'hour'
    },
    {
        name: 'by Week',
        value: 'week'
    },
    {
        name: 'by Month',
        value: 'month'
    },
    {
        name: 'by Quarter',
        value: 'quarter'
    },
    {
        name: 'by year',
        value: 'year'
    },
    {
        name: 'by Hour of the day',
        value: 'hour_day'
    },
    {
        name: 'by Day of the week',
        value: 'day_week'
    },
    {
        name: 'by week of year',
        value: 'week_year'
    },
    {
        name: 'by month of year',
        value: 'month_year'
    },
    {
        name: 'by quarter of year',
        value: 'quarter_year'
    }
    ],
    actions: {
        switchToBuilder(type, el, handleSelected) {
            this.sendAction('switchToBuilder', type, el, handleSelected);
        },
        switchToRaw(type, el, handleSelected) {
            this.sendAction('switchToRaw', type, el, handleSelected);
        },
    }
});
