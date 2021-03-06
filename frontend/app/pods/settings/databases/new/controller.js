import Ember from 'ember';

export default Ember.Controller.extend({
    db: {
        name: null,
        db_type: 'postgres',
        config: {
            host_url: null,
            host_port: null,
            db_name: null,
            username: null,
            password: null
        }
    },

    dbTypes: [
        'postgres',
        'influxdb',
        'mysql',
        'redshift'
    ],

    actions: {
        selectDbType(value) {
            this.set('db.db_type', value);
        },
        saveDatabase() {
            this.store.createRecord('database', this.get('db')).save()
                .then((response) => {
                    this.transitionToRoute('settings.databases.index');
                });

        }
    }
});
