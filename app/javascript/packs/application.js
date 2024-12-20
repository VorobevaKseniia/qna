// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import * as ActionCable from "@rails/actioncable";
import "channels"
import "../answers"
import "../questions"
import "../links"
import "../votes"
import "../alerts"
import "../comments"
import "../subscription"

var jQuery = require("jquery");
// import jQuery from "jquery";
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

require("@nathanvda/cocoon")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

var App = App || {};
App.cable = ActionCable.createConsumer();
window.App = App;