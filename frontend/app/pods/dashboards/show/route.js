import Ember from 'ember';
import AuthenticationMixin from 'frontend/mixins/authentication-mixin';
import {
    CanMixin
} from 'ember-can';


import DynamicQueryParamsRoutesMixin from 'frontend/mixins/dynamic-query-params-routes-mixin';
import KeyboardShortcuts from 'ember-keyboard-shortcuts/mixins/route';
export default Ember.Route.extend(AuthenticationMixin, CanMixin, KeyboardShortcuts, DynamicQueryParamsRoutesMixin, {
    toast: Ember.inject.service(),
    queryParams: {
        share_id: {
            refreshModel: true
        }
    },
    model(params) {
        return this.store.queryRecord('dashboard', {
            id: params.dashboard_id,
            share_id: params.share_id
        });

    },
    setupController(controller, model) {
        this._super(...arguments);
        this.set('currentController', controller);
    },
    afterModel(model) {
        if (!this.can('show dashboard')) {
            this.get('toast').error(
                'You are not authorized to perform this action',
                'Sorry Mate!', {
                    closeButton: true,
                    timeout: 1500,
                    progressBar: false
                }
            );

            return this.transitionTo('index');
        }
    },

    actions: {
        refreshQuestions() {
            this.get('currentController').refreshFunction();
        }
    },

    keyboardShortcuts: {
        'ctrl+r': 'refreshQuestions'
    }
});
