// Baloon
function CreateBaloon() {
    baloon = document.createElement('DIV');
    baloon.setAttribute('id', 'baloon');
    baloonHeader = document.createElement('DIV');
    baloonHeader.setAttribute('id', 'baloonHeader');
    baloonHeader.setAttribute('class', 'direct');
    baloonBody = document.createElement('DIV');
    baloonBody.setAttribute('id', 'baloonBody');
    baloonFooter = document.createElement('DIV');
    baloonFooter.setAttribute('id', 'baloonFooter');
    baloonBody.innerText = 'baloon';
    baloon.appendChild(baloonHeader);
    baloon.appendChild(baloonBody);
    baloon.appendChild(baloonFooter);
    baloon.onmouseover = function (e) {
        this.style.display = 'none';
    }
    baloon.onmouseout = function (e) {
        this.style.display = 'none';
    }
    baloon.onselectstart = function (e) {
        return false;
    }
    baloon.onclick = function (e) {
        this.style.display = 'none';
    }
    document.body.appendChild(baloon);
    window.onresize = function (e) {
        document.getElementById('baloon').style.display = 'none';
    }
}

function ShowBaloon(i) {
    baloon = document.getElementById('baloon');
    document.getElementById('baloonBody').innerHTML = i.getAttribute('data-notice') && i.getAttribute('data-notice').length ? i.getAttribute('data-notice') : 'Обязательное поле';
    baloon.style.display = 'block';
    var xleft = 0;
    var xtop = 0;
    o = i;
    do {
        xleft += o.offsetLeft;
        xtop += o.offsetTop;
    } while (o = o.offsetParent);
    xwidth = i.offsetWidth ? i.offsetWidth : i.style.pixelWidth;
    xheight = i.offsetHeight ? i.offsetHeight : i.style.pixelHeight;
    bwidth = baloon.offsetWidth ? baloon.offsetWidth : baloon.style.pixelWidth;
    w = window;
    xbody = document.compatMode == 'CSS1Compat' ? w.document.documentElement : w.document.body;
    dwidth = xbody.clientWidth ? xbody.clientWidth : w.innerWidth;
    bwidth = baloon.offsetWidth ? baloon.offsetWidth : baloon.style.pixelWidth;
    flip = !(xwidth - 10 + xleft + bwidth < dwidth);
    baloon.style.top = xheight - 10 + xtop + 'px';
    baloon.style.left = (xleft + xwidth - (flip ? bwidth : 0) - 25) + 'px';
    document.getElementById('baloonHeader').className = flip ? 'baloonHeaderFlip' : 'baloonHeaderDirect';
    i.focus();
    return false;
}

function ValidateForms() {
    for (i = 0; i < document.forms.length; i++) {
        if (document.forms[i].onsubmit) continue;
        document.forms[i].onsubmit = function (e) {
            $('#baloon').hide();
            var form = e ? e.target : window.event.srcElement;
            // deliveries start
            /* emsDeliveryAdditionalValidation = document.getElementById('deliveries_121');
			if (emsDeliveryAdditionalValidation && $.inArray(emsDeliveryAdditionalValidation, form.elements) != -1 && emsDeliveryAdditionalValidation.checked) {};*/
            if ($('.del_widget').is(':checked')) {
                var active_widget = $('.del_widget:checked').val();
                emsDeliveryAdditionalValidation = document.getElementById('deliveries_' + active_widget);
                var delPriceText = document.getElementById('not-null-delivery-price-' + active_widget);
                if (delPriceText.innerHTML == '---') {
                    $('.del_pay_cart_tab').show();
                    $('.return_tab_button, .delpay_tab_button').hide();
                    emsDeliveryAdditionalValidation.setAttribute('data-notice', 'Выберите пункт выдачи');
                    return ValidateNotice(emsDeliveryAdditionalValidation);
                }
            }
            // deliveries end
            for (var i = 0; i < form.elements.length; i++) {
                var value = form.elements[i].value;
                switch (form.elements[i].type) {
                    case'text':
                    case'password':
                    case'textarea':
                    case'color':
                    case'date':
                    case'datetime':
                    case'datetime-local':
                    case'email':
                    case'month':
                    case'number':
                    case'range':
                    case'search':
                    case'tel':
                    case'time':
                    case'url':
                    case'week':
                        pattern = form.elements[i].getAttribute('data-format');
                        if (pattern) {
                            switch (pattern) {
                                case'string':
                                    if (!value.length) {
                                        return ValidateNotice(form.elements[i])
                                    }
                                    break;
                                case'number':
                                    if (!isNumeric(value)) {
                                        return ValidateNotice(form.elements[i])
                                    }
                                    break;
                                case'url':
                                    if (!isUrl(value)) {
                                        return ValidateNotice(form.elements[i])
                                    }
                                    break;
                                case'email':
                                    if (!isEmail(value)) {
                                        return ValidateNotice(form.elements[i])
                                    }
                                    break;
                                default:
                                    if (!isPattern(pattern, value)) {
                                        return ValidateNotice(form.elements[i])
                                    }
                                    break
                            }
                        }
                        break;
                    case'radio':
                    case'checkbox':
                        min = form.elements[i].getAttribute('min') ? form.elements[i].getAttribute('min') : 0;
                        max = form.elements[i].getAttribute('max') ? form.elements[i].getAttribute('max') : document.getElementsByName(form.elements[i].getAttribute('name')).length;
                        if (min || max) {
                            var items = document.getElementsByName(form.elements[i].getAttribute('name'));
                            var count = 0;
                            for (var l = 0; l < items.length; l++) {
                                if (items[l].checked) {
                                    count++
                                }
                            }
                            if (count < min || count > max) {
                                return ValidateNotice(form.elements[i])
                            }
                        }
                        break;
                    case'select-one':
                    case'select-multiple':
                        selected = form.elements[i].options[form.elements[i].selectedIndex];
                        if (selected && selected.getAttribute('notselected')) {
                            return ValidateNotice(form.elements[i])
                        }
                        break;
                        break;
                    case'file':
                        break;
                    case'image':
                    case'button':
                    case'submit':
                    case'reset':
                        break;
                    default:
                        break
                }
            }
            if (typeof (additional_info) == "function") {
                additional_info()
            }
            return true
        }
    }
}

function isUrl(str) {
    return isPattern("^https?:\\/\\/(?:[a-z0-9_-]{1,32}(?::[a-z0-9_-]{1,32})?@)?(?:(?:[a-z0-9-]{1,128}\\.)+(?:com|net|org|mil|edu|arpa|gov|biz|info|aero|inc|name|[a-z]{2})|(?!0)(?:(?!0[^.]|255)[0-9]{1,3}\\.){3}(?!0|255)[0-9]{1,3})(?:\\/[a-z0-9.,_@%&?+=\\~\\/-]*)?(?:#[^ '\"&<>]*)?$", str.toLowerCase())
}

function isNumeric(str) {
    return isPattern("^[0-9]+$", str)
}

function isInteger(str) {
    return isNumeric(str)
}

function isFloat(str) {
    return isPattern("^[1-9]?[0-9]+(\\.[0-9]+)?$", str)
}

function isEmail(str) {
    return isPattern("^([a-z0-9_-]+)(\\.[a-z0-9_-]+)*@((([a-z0-9-]+\\.)+([a-z]+))|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))$", str.toLowerCase())
}

function isPattern(pattern, str) {
    if (str.length && pattern.length) {
        var re = new RegExp(pattern, "g");
        return re.test(str)
    }
    return false
}

function ValidateNotice(input) {
    ShowBaloon(input);
    return false
}

function init_balloon() {
    ValidateForms();
    CreateBaloon()
}

if (window.attachEvent) {
    window.attachEvent("onload", init_balloon)
} else if (window.addEventListener) {
    window.addEventListener("DOMContentLoaded", init_balloon, false)
} else {
    document.addEventListener("DOMContentLoaded", init_balloon, false)
}


/*! jQuery UI - v1.12.1 - 2021-01-12
* http://jqueryui.com
* Includes: widget.js, data.js, disable-selection.js, keycode.js, scroll-parent.js, widgets/draggable.js, widgets/droppable.js, widgets/resizable.js, widgets/selectable.js, widgets/sortable.js, widgets/mouse.js, widgets/slider.js
* Copyright jQuery Foundation and other contributors; Licensed MIT */

!function (t) {
    "function" == typeof define && define.amd ? define(["jquery"], t) : t(jQuery)
}(function (b) {
    b.ui = b.ui || {};
    b.ui.version = "1.12.1";
    var n, i = 0, h = Array.prototype.slice;
    b.cleanData = (n = b.cleanData, function (t) {
        for (var e, i, s = 0; null != (i = t[s]); s++) try {
            (e = b._data(i, "events")) && e.remove && b(i).triggerHandler("remove")
        } catch (t) {
        }
        n(t)
    }), b.widget = function (t, i, e) {
        var s, n, o, r = {}, h = t.split(".")[0], a = h + "-" + (t = t.split(".")[1]);
        return e || (e = i, i = b.Widget), b.isArray(e) && (e = b.extend.apply(null, [{}].concat(e))), b.expr[":"][a.toLowerCase()] = function (t) {
            return !!b.data(t, a)
        }, b[h] = b[h] || {}, s = b[h][t], n = b[h][t] = function (t, e) {
            if (!this._createWidget) return new n(t, e);
            arguments.length && this._createWidget(t, e)
        }, b.extend(n, s, {
            version: e.version,
            _proto: b.extend({}, e),
            _childConstructors: []
        }), (o = new i).options = b.widget.extend({}, o.options), b.each(e, function (e, s) {
            function n() {
                return i.prototype[e].apply(this, arguments)
            }

            function o(t) {
                return i.prototype[e].apply(this, t)
            }

            b.isFunction(s) ? r[e] = function () {
                var t, e = this._super, i = this._superApply;
                return this._super = n, this._superApply = o, t = s.apply(this, arguments), this._super = e, this._superApply = i, t
            } : r[e] = s
        }), n.prototype = b.widget.extend(o, {widgetEventPrefix: s && o.widgetEventPrefix || t}, r, {
            constructor: n,
            namespace: h,
            widgetName: t,
            widgetFullName: a
        }), s ? (b.each(s._childConstructors, function (t, e) {
            var i = e.prototype;
            b.widget(i.namespace + "." + i.widgetName, n, e._proto)
        }), delete s._childConstructors) : i._childConstructors.push(n), b.widget.bridge(t, n), n
    }, b.widget.extend = function (t) {
        for (var e, i, s = h.call(arguments, 1), n = 0, o = s.length; n < o; n++) for (e in s[n]) i = s[n][e], s[n].hasOwnProperty(e) && void 0 !== i && (b.isPlainObject(i) ? t[e] = b.isPlainObject(t[e]) ? b.widget.extend({}, t[e], i) : b.widget.extend({}, i) : t[e] = i);
        return t
    }, b.widget.bridge = function (o, e) {
        var r = e.prototype.widgetFullName || o;
        b.fn[o] = function (i) {
            var t = "string" == typeof i, s = h.call(arguments, 1), n = this;
            return t ? this.length || "instance" !== i ? this.each(function () {
                var t, e = b.data(this, r);
                return "instance" === i ? (n = e, !1) : e ? b.isFunction(e[i]) && "_" !== i.charAt(0) ? (t = e[i].apply(e, s)) !== e && void 0 !== t ? (n = t && t.jquery ? n.pushStack(t.get()) : t, !1) : void 0 : b.error("no such method '" + i + "' for " + o + " widget instance") : b.error("cannot call methods on " + o + " prior to initialization; attempted to call method '" + i + "'")
            }) : n = void 0 : (s.length && (i = b.widget.extend.apply(null, [i].concat(s))), this.each(function () {
                var t = b.data(this, r);
                t ? (t.option(i || {}), t._init && t._init()) : b.data(this, r, new e(i, this))
            })), n
        }
    }, b.Widget = function () {
    }, b.Widget._childConstructors = [], b.Widget.prototype = {
        widgetName: "widget",
        widgetEventPrefix: "",
        defaultElement: "<div>",
        options: {classes: {}, disabled: !1, create: null},
        _createWidget: function (t, e) {
            e = b(e || this.defaultElement || this)[0], this.element = b(e), this.uuid = i++, this.eventNamespace = "." + this.widgetName + this.uuid, this.bindings = b(), this.hoverable = b(), this.focusable = b(), this.classesElementLookup = {}, e !== this && (b.data(e, this.widgetFullName, this), this._on(!0, this.element, {
                remove: function (t) {
                    t.target === e && this.destroy()
                }
            }), this.document = b(e.style ? e.ownerDocument : e.document || e), this.window = b(this.document[0].defaultView || this.document[0].parentWindow)), this.options = b.widget.extend({}, this.options, this._getCreateOptions(), t), this._create(), this.options.disabled && this._setOptionDisabled(this.options.disabled), this._trigger("create", null, this._getCreateEventData()), this._init()
        },
        _getCreateOptions: function () {
            return {}
        },
        _getCreateEventData: b.noop,
        _create: b.noop,
        _init: b.noop,
        destroy: function () {
            var i = this;
            this._destroy(), b.each(this.classesElementLookup, function (t, e) {
                i._removeClass(e, t)
            }), this.element.off(this.eventNamespace).removeData(this.widgetFullName), this.widget().off(this.eventNamespace).removeAttr("aria-disabled"), this.bindings.off(this.eventNamespace)
        },
        _destroy: b.noop,
        widget: function () {
            return this.element
        },
        option: function (t, e) {
            var i, s, n, o = t;
            if (0 === arguments.length) return b.widget.extend({}, this.options);
            if ("string" == typeof t) if (o = {}, t = (i = t.split(".")).shift(), i.length) {
                for (s = o[t] = b.widget.extend({}, this.options[t]), n = 0; n < i.length - 1; n++) s[i[n]] = s[i[n]] || {}, s = s[i[n]];
                if (t = i.pop(), 1 === arguments.length) return void 0 === s[t] ? null : s[t];
                s[t] = e
            } else {
                if (1 === arguments.length) return void 0 === this.options[t] ? null : this.options[t];
                o[t] = e
            }
            return this._setOptions(o), this
        },
        _setOptions: function (t) {
            for (var e in t) this._setOption(e, t[e]);
            return this
        },
        _setOption: function (t, e) {
            return "classes" === t && this._setOptionClasses(e), this.options[t] = e, "disabled" === t && this._setOptionDisabled(e), this
        },
        _setOptionClasses: function (t) {
            var e, i, s;
            for (e in t) s = this.classesElementLookup[e], t[e] !== this.options.classes[e] && s && s.length && (i = b(s.get()), this._removeClass(s, e), i.addClass(this._classes({
                element: i,
                keys: e,
                classes: t,
                add: !0
            })))
        },
        _setOptionDisabled: function (t) {
            this._toggleClass(this.widget(), this.widgetFullName + "-disabled", null, !!t), t && (this._removeClass(this.hoverable, null, "ui-state-hover"), this._removeClass(this.focusable, null, "ui-state-focus"))
        },
        enable: function () {
            return this._setOptions({disabled: !1})
        },
        disable: function () {
            return this._setOptions({disabled: !0})
        },
        _classes: function (n) {
            var o = [], r = this;

            function t(t, e) {
                for (var i, s = 0; s < t.length; s++) i = r.classesElementLookup[t[s]] || b(), i = n.add ? b(b.unique(i.get().concat(n.element.get()))) : b(i.not(n.element).get()), r.classesElementLookup[t[s]] = i, o.push(t[s]), e && n.classes[t[s]] && o.push(n.classes[t[s]])
            }

            return n = b.extend({
                element: this.element,
                classes: this.options.classes || {}
            }, n), this._on(n.element, {remove: "_untrackClassesElement"}), n.keys && t(n.keys.match(/\S+/g) || [], !0), n.extra && t(n.extra.match(/\S+/g) || []), o.join(" ")
        },
        _untrackClassesElement: function (i) {
            var s = this;
            b.each(s.classesElementLookup, function (t, e) {
                -1 !== b.inArray(i.target, e) && (s.classesElementLookup[t] = b(e.not(i.target).get()))
            })
        },
        _removeClass: function (t, e, i) {
            return this._toggleClass(t, e, i, !1)
        },
        _addClass: function (t, e, i) {
            return this._toggleClass(t, e, i, !0)
        },
        _toggleClass: function (t, e, i, s) {
            s = "boolean" == typeof s ? s : i;
            var n = "string" == typeof t || null === t,
                t = {extra: n ? e : i, keys: n ? t : e, element: n ? this.element : t, add: s};
            return t.element.toggleClass(this._classes(t), s), this
        },
        _on: function (n, o, t) {
            var r, h = this;
            "boolean" != typeof n && (t = o, o = n, n = !1), t ? (o = r = b(o), this.bindings = this.bindings.add(o)) : (t = o, o = this.element, r = this.widget()), b.each(t, function (t, e) {
                function i() {
                    if (n || !0 !== h.options.disabled && !b(this).hasClass("ui-state-disabled")) return ("string" == typeof e ? h[e] : e).apply(h, arguments)
                }

                "string" != typeof e && (i.guid = e.guid = e.guid || i.guid || b.guid++);
                var s = t.match(/^([\w:-]*)\s*(.*)$/), t = s[1] + h.eventNamespace, s = s[2];
                s ? r.on(t, s, i) : o.on(t, i)
            })
        },
        _off: function (t, e) {
            e = (e || "").split(" ").join(this.eventNamespace + " ") + this.eventNamespace, t.off(e).off(e), this.bindings = b(this.bindings.not(t).get()), this.focusable = b(this.focusable.not(t).get()), this.hoverable = b(this.hoverable.not(t).get())
        },
        _delay: function (t, e) {
            var i = this;
            return setTimeout(function () {
                return ("string" == typeof t ? i[t] : t).apply(i, arguments)
            }, e || 0)
        },
        _hoverable: function (t) {
            this.hoverable = this.hoverable.add(t), this._on(t, {
                mouseenter: function (t) {
                    this._addClass(b(t.currentTarget), null, "ui-state-hover")
                }, mouseleave: function (t) {
                    this._removeClass(b(t.currentTarget), null, "ui-state-hover")
                }
            })
        },
        _focusable: function (t) {
            this.focusable = this.focusable.add(t), this._on(t, {
                focusin: function (t) {
                    this._addClass(b(t.currentTarget), null, "ui-state-focus")
                }, focusout: function (t) {
                    this._removeClass(b(t.currentTarget), null, "ui-state-focus")
                }
            })
        },
        _trigger: function (t, e, i) {
            var s, n, o = this.options[t];
            if (i = i || {}, (e = b.Event(e)).type = (t === this.widgetEventPrefix ? t : this.widgetEventPrefix + t).toLowerCase(), e.target = this.element[0], n = e.originalEvent) for (s in n) s in e || (e[s] = n[s]);
            return this.element.trigger(e, i), !(b.isFunction(o) && !1 === o.apply(this.element[0], [e].concat(i)) || e.isDefaultPrevented())
        }
    }, b.each({show: "fadeIn", hide: "fadeOut"}, function (o, r) {
        b.Widget.prototype["_" + o] = function (e, t, i) {
            var s;
            "string" == typeof t && (t = {effect: t});
            var n = t ? !0 !== t && "number" != typeof t && t.effect || r : o;
            "number" == typeof (t = t || {}) && (t = {duration: t}), s = !b.isEmptyObject(t), t.complete = i, t.delay && e.delay(t.delay), s && b.effects && b.effects.effect[n] ? e[o](t) : n !== o && e[n] ? e[n](t.duration, t.easing, i) : e.queue(function (t) {
                b(this)[o](), i && i.call(e[0]), t()
            })
        }
    });
    b.widget, b.extend(b.expr[":"], {
        data: b.expr.createPseudo ? b.expr.createPseudo(function (e) {
            return function (t) {
                return !!b.data(t, e)
            }
        }) : function (t, e, i) {
            return !!b.data(t, i[3])
        }
    }), b.fn.extend({
        disableSelection: (t = "onselectstart" in document.createElement("div") ? "selectstart" : "mousedown", function () {
            return this.on(t + ".ui-disableSelection", function (t) {
                t.preventDefault()
            })
        }), enableSelection: function () {
            return this.off(".ui-disableSelection")
        }
    }), b.ui.keyCode = {
        BACKSPACE: 8,
        COMMA: 188,
        DELETE: 46,
        DOWN: 40,
        END: 35,
        ENTER: 13,
        ESCAPE: 27,
        HOME: 36,
        LEFT: 37,
        PAGE_DOWN: 34,
        PAGE_UP: 33,
        PERIOD: 190,
        RIGHT: 39,
        SPACE: 32,
        TAB: 9,
        UP: 38
    }, b.fn.scrollParent = function (t) {
        var e = this.css("position"), i = "absolute" === e, s = t ? /(auto|scroll|hidden)/ : /(auto|scroll)/,
            t = this.parents().filter(function () {
                var t = b(this);
                return (!i || "static" !== t.css("position")) && s.test(t.css("overflow") + t.css("overflow-y") + t.css("overflow-x"))
            }).eq(0);
        return "fixed" !== e && t.length ? t : b(this[0].ownerDocument || document)
    }, b.ui.ie = !!/msie [\w.]+/.exec(navigator.userAgent.toLowerCase());
    var t, o = !1;
    b(document).on("mouseup", function () {
        o = !1
    });
    b.widget("ui.mouse", {
        version: "1.12.1",
        options: {cancel: "input, textarea, button, select, option", distance: 1, delay: 0},
        _mouseInit: function () {
            var e = this;
            this.element.on("mousedown." + this.widgetName, function (t) {
                return e._mouseDown(t)
            }).on("click." + this.widgetName, function (t) {
                if (!0 === b.data(t.target, e.widgetName + ".preventClickEvent")) return b.removeData(t.target, e.widgetName + ".preventClickEvent"), t.stopImmediatePropagation(), !1
            }), this.started = !1
        },
        _mouseDestroy: function () {
            this.element.off("." + this.widgetName), this._mouseMoveDelegate && this.document.off("mousemove." + this.widgetName, this._mouseMoveDelegate).off("mouseup." + this.widgetName, this._mouseUpDelegate)
        },
        _mouseDown: function (t) {
            if (!o) {
                this._mouseMoved = !1, this._mouseStarted && this._mouseUp(t), this._mouseDownEvent = t;
                var e = this, i = 1 === t.which,
                    s = !("string" != typeof this.options.cancel || !t.target.nodeName) && b(t.target).closest(this.options.cancel).length;
                return i && !s && this._mouseCapture(t) ? (this.mouseDelayMet = !this.options.delay, this.mouseDelayMet || (this._mouseDelayTimer = setTimeout(function () {
                    e.mouseDelayMet = !0
                }, this.options.delay)), this._mouseDistanceMet(t) && this._mouseDelayMet(t) && (this._mouseStarted = !1 !== this._mouseStart(t), !this._mouseStarted) ? (t.preventDefault(), !0) : (!0 === b.data(t.target, this.widgetName + ".preventClickEvent") && b.removeData(t.target, this.widgetName + ".preventClickEvent"), this._mouseMoveDelegate = function (t) {
                    return e._mouseMove(t)
                }, this._mouseUpDelegate = function (t) {
                    return e._mouseUp(t)
                }, this.document.on("mousemove." + this.widgetName, this._mouseMoveDelegate).on("mouseup." + this.widgetName, this._mouseUpDelegate), t.preventDefault(), o = !0)) : !0
            }
        },
        _mouseMove: function (t) {
            if (this._mouseMoved) {
                if (b.ui.ie && (!document.documentMode || document.documentMode < 9) && !t.button) return this._mouseUp(t);
                if (!t.which) if (t.originalEvent.altKey || t.originalEvent.ctrlKey || t.originalEvent.metaKey || t.originalEvent.shiftKey) this.ignoreMissingWhich = !0; else if (!this.ignoreMissingWhich) return this._mouseUp(t)
            }
            return (t.which || t.button) && (this._mouseMoved = !0), this._mouseStarted ? (this._mouseDrag(t), t.preventDefault()) : (this._mouseDistanceMet(t) && this._mouseDelayMet(t) && (this._mouseStarted = !1 !== this._mouseStart(this._mouseDownEvent, t), this._mouseStarted ? this._mouseDrag(t) : this._mouseUp(t)), !this._mouseStarted)
        },
        _mouseUp: function (t) {
            this.document.off("mousemove." + this.widgetName, this._mouseMoveDelegate).off("mouseup." + this.widgetName, this._mouseUpDelegate), this._mouseStarted && (this._mouseStarted = !1, t.target === this._mouseDownEvent.target && b.data(t.target, this.widgetName + ".preventClickEvent", !0), this._mouseStop(t)), this._mouseDelayTimer && (clearTimeout(this._mouseDelayTimer), delete this._mouseDelayTimer), this.ignoreMissingWhich = !1, o = !1, t.preventDefault()
        },
        _mouseDistanceMet: function (t) {
            return Math.max(Math.abs(this._mouseDownEvent.pageX - t.pageX), Math.abs(this._mouseDownEvent.pageY - t.pageY)) >= this.options.distance
        },
        _mouseDelayMet: function () {
            return this.mouseDelayMet
        },
        _mouseStart: function () {
        },
        _mouseDrag: function () {
        },
        _mouseStop: function () {
        },
        _mouseCapture: function () {
            return !0
        }
    }), b.ui.plugin = {
        add: function (t, e, i) {
            var s, n = b.ui[t].prototype;
            for (s in i) n.plugins[s] = n.plugins[s] || [], n.plugins[s].push([e, i[s]])
        }, call: function (t, e, i, s) {
            var n, o = t.plugins[e];
            if (o && (s || t.element[0].parentNode && 11 !== t.element[0].parentNode.nodeType)) for (n = 0; n < o.length; n++) t.options[o[n][0]] && o[n][1].apply(t.element, i)
        }
    }, b.ui.safeActiveElement = function (e) {
        var i;
        try {
            i = e.activeElement
        } catch (t) {
            i = e.body
        }
        return (i = i || e.body).nodeName || (i = e.body), i
    }, b.ui.safeBlur = function (t) {
        t && "body" !== t.nodeName.toLowerCase() && b(t).trigger("blur")
    };
    b.widget("ui.draggable", b.ui.mouse, {
        version: "1.12.1",
        widgetEventPrefix: "drag",
        options: {
            addClasses: !0,
            appendTo: "parent",
            axis: !1,
            connectToSortable: !1,
            containment: !1,
            cursor: "auto",
            cursorAt: !1,
            grid: !1,
            handle: !1,
            helper: "original",
            iframeFix: !1,
            opacity: !1,
            refreshPositions: !1,
            revert: !1,
            revertDuration: 500,
            scope: "default",
            scroll: !0,
            scrollSensitivity: 20,
            scrollSpeed: 20,
            snap: !1,
            snapMode: "both",
            snapTolerance: 20,
            stack: !1,
            zIndex: !1,
            drag: null,
            start: null,
            stop: null
        },
        _create: function () {
            "original" === this.options.helper && this._setPositionRelative(), this.options.addClasses && this._addClass("ui-draggable"), this._setHandleClassName(), this._mouseInit()
        },
        _setOption: function (t, e) {
            this._super(t, e), "handle" === t && (this._removeHandleClassName(), this._setHandleClassName())
        },
        _destroy: function () {
            (this.helper || this.element).is(".ui-draggable-dragging") ? this.destroyOnClear = !0 : (this._removeHandleClassName(), this._mouseDestroy())
        },
        _mouseCapture: function (t) {
            var e = this.options;
            return !(this.helper || e.disabled || 0 < b(t.target).closest(".ui-resizable-handle").length) && (this.handle = this._getHandle(t), !!this.handle && (this._blurActiveElement(t), this._blockFrames(!0 === e.iframeFix ? "iframe" : e.iframeFix), !0))
        },
        _blockFrames: function (t) {
            this.iframeBlocks = this.document.find(t).map(function () {
                var t = b(this);
                return b("<div>").css("position", "absolute").appendTo(t.parent()).outerWidth(t.outerWidth()).outerHeight(t.outerHeight()).offset(t.offset())[0]
            })
        },
        _unblockFrames: function () {
            this.iframeBlocks && (this.iframeBlocks.remove(), delete this.iframeBlocks)
        },
        _blurActiveElement: function (t) {
            var e = b.ui.safeActiveElement(this.document[0]);
            b(t.target).closest(e).length || b.ui.safeBlur(e)
        },
        _mouseStart: function (t) {
            var e = this.options;
            return this.helper = this._createHelper(t), this._addClass(this.helper, "ui-draggable-dragging"), this._cacheHelperProportions(), b.ui.ddmanager && (b.ui.ddmanager.current = this), this._cacheMargins(), this.cssPosition = this.helper.css("position"), this.scrollParent = this.helper.scrollParent(!0), this.offsetParent = this.helper.offsetParent(), this.hasFixedAncestor = 0 < this.helper.parents().filter(function () {
                return "fixed" === b(this).css("position")
            }).length, this.positionAbs = this.element.offset(), this._refreshOffsets(t), this.originalPosition = this.position = this._generatePosition(t, !1), this.originalPageX = t.pageX, this.originalPageY = t.pageY, e.cursorAt && this._adjustOffsetFromHelper(e.cursorAt), this._setContainment(), !1 === this._trigger("start", t) ? (this._clear(), !1) : (this._cacheHelperProportions(), b.ui.ddmanager && !e.dropBehaviour && b.ui.ddmanager.prepareOffsets(this, t), this._mouseDrag(t, !0), b.ui.ddmanager && b.ui.ddmanager.dragStart(this, t), !0)
        },
        _refreshOffsets: function (t) {
            this.offset = {
                top: this.positionAbs.top - this.margins.top,
                left: this.positionAbs.left - this.margins.left,
                scroll: !1,
                parent: this._getParentOffset(),
                relative: this._getRelativeOffset()
            }, this.offset.click = {left: t.pageX - this.offset.left, top: t.pageY - this.offset.top}
        },
        _mouseDrag: function (t, e) {
            if (this.hasFixedAncestor && (this.offset.parent = this._getParentOffset()), this.position = this._generatePosition(t, !0), this.positionAbs = this._convertPositionTo("absolute"), !e) {
                e = this._uiHash();
                if (!1 === this._trigger("drag", t, e)) return this._mouseUp(new b.Event("mouseup", t)), !1;
                this.position = e.position
            }
            return this.helper[0].style.left = this.position.left + "px", this.helper[0].style.top = this.position.top + "px", b.ui.ddmanager && b.ui.ddmanager.drag(this, t), !1
        },
        _mouseStop: function (t) {
            var e = this, i = !1;
            return b.ui.ddmanager && !this.options.dropBehaviour && (i = b.ui.ddmanager.drop(this, t)), this.dropped && (i = this.dropped, this.dropped = !1), "invalid" === this.options.revert && !i || "valid" === this.options.revert && i || !0 === this.options.revert || b.isFunction(this.options.revert) && this.options.revert.call(this.element, i) ? b(this.helper).animate(this.originalPosition, parseInt(this.options.revertDuration, 10), function () {
                !1 !== e._trigger("stop", t) && e._clear()
            }) : !1 !== this._trigger("stop", t) && this._clear(), !1
        },
        _mouseUp: function (t) {
            return this._unblockFrames(), b.ui.ddmanager && b.ui.ddmanager.dragStop(this, t), this.handleElement.is(t.target) && this.element.trigger("focus"), b.ui.mouse.prototype._mouseUp.call(this, t)
        },
        cancel: function () {
            return this.helper.is(".ui-draggable-dragging") ? this._mouseUp(new b.Event("mouseup", {target: this.element[0]})) : this._clear(), this
        },
        _getHandle: function (t) {
            return !this.options.handle || !!b(t.target).closest(this.element.find(this.options.handle)).length
        },
        _setHandleClassName: function () {
            this.handleElement = this.options.handle ? this.element.find(this.options.handle) : this.element, this._addClass(this.handleElement, "ui-draggable-handle")
        },
        _removeHandleClassName: function () {
            this._removeClass(this.handleElement, "ui-draggable-handle")
        },
        _createHelper: function (t) {
            var e = this.options, i = b.isFunction(e.helper),
                t = i ? b(e.helper.apply(this.element[0], [t])) : "clone" === e.helper ? this.element.clone().removeAttr("id") : this.element;
            return t.parents("body").length || t.appendTo("parent" === e.appendTo ? this.element[0].parentNode : e.appendTo), i && t[0] === this.element[0] && this._setPositionRelative(), t[0] === this.element[0] || /(fixed|absolute)/.test(t.css("position")) || t.css("position", "absolute"), t
        },
        _setPositionRelative: function () {
            /^(?:r|a|f)/.test(this.element.css("position")) || (this.element[0].style.position = "relative")
        },
        _adjustOffsetFromHelper: function (t) {
            "string" == typeof t && (t = t.split(" ")), b.isArray(t) && (t = {
                left: +t[0],
                top: +t[1] || 0
            }), "left" in t && (this.offset.click.left = t.left + this.margins.left), "right" in t && (this.offset.click.left = this.helperProportions.width - t.right + this.margins.left), "top" in t && (this.offset.click.top = t.top + this.margins.top), "bottom" in t && (this.offset.click.top = this.helperProportions.height - t.bottom + this.margins.top)
        },
        _isRootNode: function (t) {
            return /(html|body)/i.test(t.tagName) || t === this.document[0]
        },
        _getParentOffset: function () {
            var t = this.offsetParent.offset(), e = this.document[0];
            return "absolute" === this.cssPosition && this.scrollParent[0] !== e && b.contains(this.scrollParent[0], this.offsetParent[0]) && (t.left += this.scrollParent.scrollLeft(), t.top += this.scrollParent.scrollTop()), this._isRootNode(this.offsetParent[0]) && (t = {
                top: 0,
                left: 0
            }), {
                top: t.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
                left: t.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
            }
        },
        _getRelativeOffset: function () {
            if ("relative" !== this.cssPosition) return {top: 0, left: 0};
            var t = this.element.position(), e = this._isRootNode(this.scrollParent[0]);
            return {
                top: t.top - (parseInt(this.helper.css("top"), 10) || 0) + (e ? 0 : this.scrollParent.scrollTop()),
                left: t.left - (parseInt(this.helper.css("left"), 10) || 0) + (e ? 0 : this.scrollParent.scrollLeft())
            }
        },
        _cacheMargins: function () {
            this.margins = {
                left: parseInt(this.element.css("marginLeft"), 10) || 0,
                top: parseInt(this.element.css("marginTop"), 10) || 0,
                right: parseInt(this.element.css("marginRight"), 10) || 0,
                bottom: parseInt(this.element.css("marginBottom"), 10) || 0
            }
        },
        _cacheHelperProportions: function () {
            this.helperProportions = {width: this.helper.outerWidth(), height: this.helper.outerHeight()}
        },
        _setContainment: function () {
            var t, e, i, s = this.options, n = this.document[0];
            this.relativeContainer = null, s.containment ? "window" !== s.containment ? "document" !== s.containment ? s.containment.constructor !== Array ? ("parent" === s.containment && (s.containment = this.helper[0].parentNode), (i = (e = b(s.containment))[0]) && (t = /(scroll|auto)/.test(e.css("overflow")), this.containment = [(parseInt(e.css("borderLeftWidth"), 10) || 0) + (parseInt(e.css("paddingLeft"), 10) || 0), (parseInt(e.css("borderTopWidth"), 10) || 0) + (parseInt(e.css("paddingTop"), 10) || 0), (t ? Math.max(i.scrollWidth, i.offsetWidth) : i.offsetWidth) - (parseInt(e.css("borderRightWidth"), 10) || 0) - (parseInt(e.css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left - this.margins.right, (t ? Math.max(i.scrollHeight, i.offsetHeight) : i.offsetHeight) - (parseInt(e.css("borderBottomWidth"), 10) || 0) - (parseInt(e.css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top - this.margins.bottom], this.relativeContainer = e)) : this.containment = s.containment : this.containment = [0, 0, b(n).width() - this.helperProportions.width - this.margins.left, (b(n).height() || n.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top] : this.containment = [b(window).scrollLeft() - this.offset.relative.left - this.offset.parent.left, b(window).scrollTop() - this.offset.relative.top - this.offset.parent.top, b(window).scrollLeft() + b(window).width() - this.helperProportions.width - this.margins.left, b(window).scrollTop() + (b(window).height() || n.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top] : this.containment = null
        },
        _convertPositionTo: function (t, e) {
            e = e || this.position;
            var i = "absolute" === t ? 1 : -1, t = this._isRootNode(this.scrollParent[0]);
            return {
                top: e.top + this.offset.relative.top * i + this.offset.parent.top * i - ("fixed" === this.cssPosition ? -this.offset.scroll.top : t ? 0 : this.offset.scroll.top) * i,
                left: e.left + this.offset.relative.left * i + this.offset.parent.left * i - ("fixed" === this.cssPosition ? -this.offset.scroll.left : t ? 0 : this.offset.scroll.left) * i
            }
        },
        _generatePosition: function (t, e) {
            var i, s = this.options, n = this._isRootNode(this.scrollParent[0]), o = t.pageX, r = t.pageY;
            return n && this.offset.scroll || (this.offset.scroll = {
                top: this.scrollParent.scrollTop(),
                left: this.scrollParent.scrollLeft()
            }), e && (this.containment && (i = this.relativeContainer ? (i = this.relativeContainer.offset(), [this.containment[0] + i.left, this.containment[1] + i.top, this.containment[2] + i.left, this.containment[3] + i.top]) : this.containment, t.pageX - this.offset.click.left < i[0] && (o = i[0] + this.offset.click.left), t.pageY - this.offset.click.top < i[1] && (r = i[1] + this.offset.click.top), t.pageX - this.offset.click.left > i[2] && (o = i[2] + this.offset.click.left), t.pageY - this.offset.click.top > i[3] && (r = i[3] + this.offset.click.top)), s.grid && (t = s.grid[1] ? this.originalPageY + Math.round((r - this.originalPageY) / s.grid[1]) * s.grid[1] : this.originalPageY, r = !i || t - this.offset.click.top >= i[1] || t - this.offset.click.top > i[3] ? t : t - this.offset.click.top >= i[1] ? t - s.grid[1] : t + s.grid[1], t = s.grid[0] ? this.originalPageX + Math.round((o - this.originalPageX) / s.grid[0]) * s.grid[0] : this.originalPageX, o = !i || t - this.offset.click.left >= i[0] || t - this.offset.click.left > i[2] ? t : t - this.offset.click.left >= i[0] ? t - s.grid[0] : t + s.grid[0]), "y" === s.axis && (o = this.originalPageX), "x" === s.axis && (r = this.originalPageY)), {
                top: r - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + ("fixed" === this.cssPosition ? -this.offset.scroll.top : n ? 0 : this.offset.scroll.top),
                left: o - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + ("fixed" === this.cssPosition ? -this.offset.scroll.left : n ? 0 : this.offset.scroll.left)
            }
        },
        _clear: function () {
            this._removeClass(this.helper, "ui-draggable-dragging"), this.helper[0] === this.element[0] || this.cancelHelperRemoval || this.helper.remove(), this.helper = null, this.cancelHelperRemoval = !1, this.destroyOnClear && this.destroy()
        },
        _trigger: function (t, e, i) {
            return i = i || this._uiHash(), b.ui.plugin.call(this, t, [e, i, this], !0), /^(drag|start|stop)/.test(t) && (this.positionAbs = this._convertPositionTo("absolute"), i.offset = this.positionAbs), b.Widget.prototype._trigger.call(this, t, e, i)
        },
        plugins: {},
        _uiHash: function () {
            return {
                helper: this.helper,
                position: this.position,
                originalPosition: this.originalPosition,
                offset: this.positionAbs
            }
        }
    }), b.ui.plugin.add("draggable", "connectToSortable", {
        start: function (e, t, i) {
            var s = b.extend({}, t, {item: i.element});
            i.sortables = [], b(i.options.connectToSortable).each(function () {
                var t = b(this).sortable("instance");
                t && !t.options.disabled && (i.sortables.push(t), t.refreshPositions(), t._trigger("activate", e, s))
            })
        }, stop: function (e, t, i) {
            var s = b.extend({}, t, {item: i.element});
            i.cancelHelperRemoval = !1, b.each(i.sortables, function () {
                var t = this;
                t.isOver ? (t.isOver = 0, i.cancelHelperRemoval = !0, t.cancelHelperRemoval = !1, t._storedCSS = {
                    position: t.placeholder.css("position"),
                    top: t.placeholder.css("top"),
                    left: t.placeholder.css("left")
                }, t._mouseStop(e), t.options.helper = t.options._helper) : (t.cancelHelperRemoval = !0, t._trigger("deactivate", e, s))
            })
        }, drag: function (i, s, n) {
            b.each(n.sortables, function () {
                var t = !1, e = this;
                e.positionAbs = n.positionAbs, e.helperProportions = n.helperProportions, e.offset.click = n.offset.click, e._intersectsWith(e.containerCache) && (t = !0, b.each(n.sortables, function () {
                    return this.positionAbs = n.positionAbs, this.helperProportions = n.helperProportions, this.offset.click = n.offset.click, this !== e && this._intersectsWith(this.containerCache) && b.contains(e.element[0], this.element[0]) && (t = !1), t
                })), t ? (e.isOver || (e.isOver = 1, n._parent = s.helper.parent(), e.currentItem = s.helper.appendTo(e.element).data("ui-sortable-item", !0), e.options._helper = e.options.helper, e.options.helper = function () {
                    return s.helper[0]
                }, i.target = e.currentItem[0], e._mouseCapture(i, !0), e._mouseStart(i, !0, !0), e.offset.click.top = n.offset.click.top, e.offset.click.left = n.offset.click.left, e.offset.parent.left -= n.offset.parent.left - e.offset.parent.left, e.offset.parent.top -= n.offset.parent.top - e.offset.parent.top, n._trigger("toSortable", i), n.dropped = e.element, b.each(n.sortables, function () {
                    this.refreshPositions()
                }), n.currentItem = n.element, e.fromOutside = n), e.currentItem && (e._mouseDrag(i), s.position = e.position)) : e.isOver && (e.isOver = 0, e.cancelHelperRemoval = !0, e.options._revert = e.options.revert, e.options.revert = !1, e._trigger("out", i, e._uiHash(e)), e._mouseStop(i, !0), e.options.revert = e.options._revert, e.options.helper = e.options._helper, e.placeholder && e.placeholder.remove(), s.helper.appendTo(n._parent), n._refreshOffsets(i), s.position = n._generatePosition(i, !0), n._trigger("fromSortable", i), n.dropped = !1, b.each(n.sortables, function () {
                    this.refreshPositions()
                }))
            })
        }
    }), b.ui.plugin.add("draggable", "cursor", {
        start: function (t, e, i) {
            var s = b("body"), i = i.options;
            s.css("cursor") && (i._cursor = s.css("cursor")), s.css("cursor", i.cursor)
        }, stop: function (t, e, i) {
            i = i.options;
            i._cursor && b("body").css("cursor", i._cursor)
        }
    }), b.ui.plugin.add("draggable", "opacity", {
        start: function (t, e, i) {
            e = b(e.helper), i = i.options;
            e.css("opacity") && (i._opacity = e.css("opacity")), e.css("opacity", i.opacity)
        }, stop: function (t, e, i) {
            i = i.options;
            i._opacity && b(e.helper).css("opacity", i._opacity)
        }
    }), b.ui.plugin.add("draggable", "scroll", {
        start: function (t, e, i) {
            i.scrollParentNotHidden || (i.scrollParentNotHidden = i.helper.scrollParent(!1)), i.scrollParentNotHidden[0] !== i.document[0] && "HTML" !== i.scrollParentNotHidden[0].tagName && (i.overflowOffset = i.scrollParentNotHidden.offset())
        }, drag: function (t, e, i) {
            var s = i.options, n = !1, o = i.scrollParentNotHidden[0], r = i.document[0];
            o !== r && "HTML" !== o.tagName ? (s.axis && "x" === s.axis || (i.overflowOffset.top + o.offsetHeight - t.pageY < s.scrollSensitivity ? o.scrollTop = n = o.scrollTop + s.scrollSpeed : t.pageY - i.overflowOffset.top < s.scrollSensitivity && (o.scrollTop = n = o.scrollTop - s.scrollSpeed)), s.axis && "y" === s.axis || (i.overflowOffset.left + o.offsetWidth - t.pageX < s.scrollSensitivity ? o.scrollLeft = n = o.scrollLeft + s.scrollSpeed : t.pageX - i.overflowOffset.left < s.scrollSensitivity && (o.scrollLeft = n = o.scrollLeft - s.scrollSpeed))) : (s.axis && "x" === s.axis || (t.pageY - b(r).scrollTop() < s.scrollSensitivity ? n = b(r).scrollTop(b(r).scrollTop() - s.scrollSpeed) : b(window).height() - (t.pageY - b(r).scrollTop()) < s.scrollSensitivity && (n = b(r).scrollTop(b(r).scrollTop() + s.scrollSpeed))), s.axis && "y" === s.axis || (t.pageX - b(r).scrollLeft() < s.scrollSensitivity ? n = b(r).scrollLeft(b(r).scrollLeft() - s.scrollSpeed) : b(window).width() - (t.pageX - b(r).scrollLeft()) < s.scrollSensitivity && (n = b(r).scrollLeft(b(r).scrollLeft() + s.scrollSpeed)))), !1 !== n && b.ui.ddmanager && !s.dropBehaviour && b.ui.ddmanager.prepareOffsets(i, t)
        }
    }), b.ui.plugin.add("draggable", "snap", {
        start: function (t, e, i) {
            var s = i.options;
            i.snapElements = [], b(s.snap.constructor !== String ? s.snap.items || ":data(ui-draggable)" : s.snap).each(function () {
                var t = b(this), e = t.offset();
                this !== i.element[0] && i.snapElements.push({
                    item: this,
                    width: t.outerWidth(),
                    height: t.outerHeight(),
                    top: e.top,
                    left: e.left
                })
            })
        }, drag: function (t, e, i) {
            for (var s, n, o, r, h, a, l, c, p, u = i.options, d = u.snapTolerance, f = e.offset.left, g = f + i.helperProportions.width, m = e.offset.top, _ = m + i.helperProportions.height, v = i.snapElements.length - 1; 0 <= v; v--) a = (h = i.snapElements[v].left - i.margins.left) + i.snapElements[v].width, c = (l = i.snapElements[v].top - i.margins.top) + i.snapElements[v].height, g < h - d || a + d < f || _ < l - d || c + d < m || !b.contains(i.snapElements[v].item.ownerDocument, i.snapElements[v].item) ? (i.snapElements[v].snapping && i.options.snap.release && i.options.snap.release.call(i.element, t, b.extend(i._uiHash(), {snapItem: i.snapElements[v].item})), i.snapElements[v].snapping = !1) : ("inner" !== u.snapMode && (s = Math.abs(l - _) <= d, n = Math.abs(c - m) <= d, o = Math.abs(h - g) <= d, r = Math.abs(a - f) <= d, s && (e.position.top = i._convertPositionTo("relative", {
                top: l - i.helperProportions.height,
                left: 0
            }).top), n && (e.position.top = i._convertPositionTo("relative", {
                top: c,
                left: 0
            }).top), o && (e.position.left = i._convertPositionTo("relative", {
                top: 0,
                left: h - i.helperProportions.width
            }).left), r && (e.position.left = i._convertPositionTo("relative", {
                top: 0,
                left: a
            }).left)), p = s || n || o || r, "outer" !== u.snapMode && (s = Math.abs(l - m) <= d, n = Math.abs(c - _) <= d, o = Math.abs(h - f) <= d, r = Math.abs(a - g) <= d, s && (e.position.top = i._convertPositionTo("relative", {
                top: l,
                left: 0
            }).top), n && (e.position.top = i._convertPositionTo("relative", {
                top: c - i.helperProportions.height,
                left: 0
            }).top), o && (e.position.left = i._convertPositionTo("relative", {
                top: 0,
                left: h
            }).left), r && (e.position.left = i._convertPositionTo("relative", {
                top: 0,
                left: a - i.helperProportions.width
            }).left)), !i.snapElements[v].snapping && (s || n || o || r || p) && i.options.snap.snap && i.options.snap.snap.call(i.element, t, b.extend(i._uiHash(), {snapItem: i.snapElements[v].item})), i.snapElements[v].snapping = s || n || o || r || p)
        }
    }), b.ui.plugin.add("draggable", "stack", {
        start: function (t, e, i) {
            var s, i = i.options, i = b.makeArray(b(i.stack)).sort(function (t, e) {
                return (parseInt(b(t).css("zIndex"), 10) || 0) - (parseInt(b(e).css("zIndex"), 10) || 0)
            });
            i.length && (s = parseInt(b(i[0]).css("zIndex"), 10) || 0, b(i).each(function (t) {
                b(this).css("zIndex", s + t)
            }), this.css("zIndex", s + i.length))
        }
    }), b.ui.plugin.add("draggable", "zIndex", {
        start: function (t, e, i) {
            e = b(e.helper), i = i.options;
            e.css("zIndex") && (i._zIndex = e.css("zIndex")), e.css("zIndex", i.zIndex)
        }, stop: function (t, e, i) {
            i = i.options;
            i._zIndex && b(e.helper).css("zIndex", i._zIndex)
        }
    });
    b.ui.draggable;
    b.widget("ui.droppable", {
        version: "1.12.1",
        widgetEventPrefix: "drop",
        options: {
            accept: "*",
            addClasses: !0,
            greedy: !1,
            scope: "default",
            tolerance: "intersect",
            activate: null,
            deactivate: null,
            drop: null,
            out: null,
            over: null
        },
        _create: function () {
            var t, e = this.options, i = e.accept;
            this.isover = !1, this.isout = !0, this.accept = b.isFunction(i) ? i : function (t) {
                return t.is(i)
            }, this.proportions = function () {
                if (!arguments.length) return t || (t = {
                    width: this.element[0].offsetWidth,
                    height: this.element[0].offsetHeight
                });
                t = arguments[0]
            }, this._addToManager(e.scope), e.addClasses && this._addClass("ui-droppable")
        },
        _addToManager: function (t) {
            b.ui.ddmanager.droppables[t] = b.ui.ddmanager.droppables[t] || [], b.ui.ddmanager.droppables[t].push(this)
        },
        _splice: function (t) {
            for (var e = 0; e < t.length; e++) t[e] === this && t.splice(e, 1)
        },
        _destroy: function () {
            var t = b.ui.ddmanager.droppables[this.options.scope];
            this._splice(t)
        },
        _setOption: function (t, e) {
            var i;
            "accept" === t ? this.accept = b.isFunction(e) ? e : function (t) {
                return t.is(e)
            } : "scope" === t && (i = b.ui.ddmanager.droppables[this.options.scope], this._splice(i), this._addToManager(e)), this._super(t, e)
        },
        _activate: function (t) {
            var e = b.ui.ddmanager.current;
            this._addActiveClass(), e && this._trigger("activate", t, this.ui(e))
        },
        _deactivate: function (t) {
            var e = b.ui.ddmanager.current;
            this._removeActiveClass(), e && this._trigger("deactivate", t, this.ui(e))
        },
        _over: function (t) {
            var e = b.ui.ddmanager.current;
            e && (e.currentItem || e.element)[0] !== this.element[0] && this.accept.call(this.element[0], e.currentItem || e.element) && (this._addHoverClass(), this._trigger("over", t, this.ui(e)))
        },
        _out: function (t) {
            var e = b.ui.ddmanager.current;
            e && (e.currentItem || e.element)[0] !== this.element[0] && this.accept.call(this.element[0], e.currentItem || e.element) && (this._removeHoverClass(), this._trigger("out", t, this.ui(e)))
        },
        _drop: function (e, t) {
            var i = t || b.ui.ddmanager.current, s = !1;
            return !(!i || (i.currentItem || i.element)[0] === this.element[0]) && (this.element.find(":data(ui-droppable)").not(".ui-draggable-dragging").each(function () {
                var t = b(this).droppable("instance");
                if (t.options.greedy && !t.options.disabled && t.options.scope === i.options.scope && t.accept.call(t.element[0], i.currentItem || i.element) && r(i, b.extend(t, {offset: t.element.offset()}), t.options.tolerance, e)) return !(s = !0)
            }), !s && (!!this.accept.call(this.element[0], i.currentItem || i.element) && (this._removeActiveClass(), this._removeHoverClass(), this._trigger("drop", e, this.ui(i)), this.element)))
        },
        ui: function (t) {
            return {
                draggable: t.currentItem || t.element,
                helper: t.helper,
                position: t.position,
                offset: t.positionAbs
            }
        },
        _addHoverClass: function () {
            this._addClass("ui-droppable-hover")
        },
        _removeHoverClass: function () {
            this._removeClass("ui-droppable-hover")
        },
        _addActiveClass: function () {
            this._addClass("ui-droppable-active")
        },
        _removeActiveClass: function () {
            this._removeClass("ui-droppable-active")
        }
    });
    var r = b.ui.intersect = function (t, e, i, s) {
        if (!e.offset) return !1;
        var n = (t.positionAbs || t.position.absolute).left + t.margins.left,
            o = (t.positionAbs || t.position.absolute).top + t.margins.top, r = n + t.helperProportions.width,
            h = o + t.helperProportions.height, a = e.offset.left, l = e.offset.top, c = a + e.proportions().width,
            p = l + e.proportions().height;
        switch (i) {
            case"fit":
                return a <= n && r <= c && l <= o && h <= p;
            case"intersect":
                return a < n + t.helperProportions.width / 2 && r - t.helperProportions.width / 2 < c && l < o + t.helperProportions.height / 2 && h - t.helperProportions.height / 2 < p;
            case"pointer":
                return u(s.pageY, l, e.proportions().height) && u(s.pageX, a, e.proportions().width);
            case"touch":
                return (l <= o && o <= p || l <= h && h <= p || o < l && p < h) && (a <= n && n <= c || a <= r && r <= c || n < a && c < r);
            default:
                return !1
        }
    };

    function u(t, e, i) {
        return e <= t && t < e + i
    }

    !(b.ui.ddmanager = {
        current: null, droppables: {default: []}, prepareOffsets: function (t, e) {
            var i, s, n = b.ui.ddmanager.droppables[t.options.scope] || [], o = e ? e.type : null,
                r = (t.currentItem || t.element).find(":data(ui-droppable)").addBack();
            t:for (i = 0; i < n.length; i++) if (!(n[i].options.disabled || t && !n[i].accept.call(n[i].element[0], t.currentItem || t.element))) {
                for (s = 0; s < r.length; s++) if (r[s] === n[i].element[0]) {
                    n[i].proportions().height = 0;
                    continue t
                }
                n[i].visible = "none" !== n[i].element.css("display"), n[i].visible && ("mousedown" === o && n[i]._activate.call(n[i], e), n[i].offset = n[i].element.offset(), n[i].proportions({
                    width: n[i].element[0].offsetWidth,
                    height: n[i].element[0].offsetHeight
                }))
            }
        }, drop: function (t, e) {
            var i = !1;
            return b.each((b.ui.ddmanager.droppables[t.options.scope] || []).slice(), function () {
                this.options && (!this.options.disabled && this.visible && r(t, this, this.options.tolerance, e) && (i = this._drop.call(this, e) || i), !this.options.disabled && this.visible && this.accept.call(this.element[0], t.currentItem || t.element) && (this.isout = !0, this.isover = !1, this._deactivate.call(this, e)))
            }), i
        }, dragStart: function (t, e) {
            t.element.parentsUntil("body").on("scroll.droppable", function () {
                t.options.refreshPositions || b.ui.ddmanager.prepareOffsets(t, e)
            })
        }, drag: function (n, o) {
            n.options.refreshPositions && b.ui.ddmanager.prepareOffsets(n, o), b.each(b.ui.ddmanager.droppables[n.options.scope] || [], function () {
                var t, e, i, s;
                this.options.disabled || this.greedyChild || !this.visible || (s = !(i = r(n, this, this.options.tolerance, o)) && this.isover ? "isout" : i && !this.isover ? "isover" : null) && (this.options.greedy && (e = this.options.scope, (i = this.element.parents(":data(ui-droppable)").filter(function () {
                    return b(this).droppable("instance").options.scope === e
                })).length && ((t = b(i[0]).droppable("instance")).greedyChild = "isover" === s)), t && "isover" === s && (t.isover = !1, t.isout = !0, t._out.call(t, o)), this[s] = !0, this["isout" === s ? "isover" : "isout"] = !1, this["isover" === s ? "_over" : "_out"].call(this, o), t && "isout" === s && (t.isout = !1, t.isover = !0, t._over.call(t, o)))
            })
        }, dragStop: function (t, e) {
            t.element.parentsUntil("body").off("scroll.droppable"), t.options.refreshPositions || b.ui.ddmanager.prepareOffsets(t, e)
        }
    }) !== b.uiBackCompat && b.widget("ui.droppable", b.ui.droppable, {
        options: {hoverClass: !1, activeClass: !1},
        _addActiveClass: function () {
            this._super(), this.options.activeClass && this.element.addClass(this.options.activeClass)
        },
        _removeActiveClass: function () {
            this._super(), this.options.activeClass && this.element.removeClass(this.options.activeClass)
        },
        _addHoverClass: function () {
            this._super(), this.options.hoverClass && this.element.addClass(this.options.hoverClass)
        },
        _removeHoverClass: function () {
            this._super(), this.options.hoverClass && this.element.removeClass(this.options.hoverClass)
        }
    });
    b.ui.droppable;
    b.widget("ui.resizable", b.ui.mouse, {
        version: "1.12.1",
        widgetEventPrefix: "resize",
        options: {
            alsoResize: !1,
            animate: !1,
            animateDuration: "slow",
            animateEasing: "swing",
            aspectRatio: !1,
            autoHide: !1,
            classes: {"ui-resizable-se": "ui-icon ui-icon-gripsmall-diagonal-se"},
            containment: !1,
            ghost: !1,
            grid: !1,
            handles: "e,s,se",
            helper: !1,
            maxHeight: null,
            maxWidth: null,
            minHeight: 10,
            minWidth: 10,
            zIndex: 90,
            resize: null,
            start: null,
            stop: null
        },
        _num: function (t) {
            return parseFloat(t) || 0
        },
        _isNumber: function (t) {
            return !isNaN(parseFloat(t))
        },
        _hasScroll: function (t, e) {
            if ("hidden" === b(t).css("overflow")) return !1;
            var i = e && "left" === e ? "scrollLeft" : "scrollTop", e = !1;
            return 0 < t[i] || (t[i] = 1, e = 0 < t[i], t[i] = 0, e)
        },
        _create: function () {
            var t, e = this.options, i = this;
            this._addClass("ui-resizable"), b.extend(this, {
                _aspectRatio: !!e.aspectRatio,
                aspectRatio: e.aspectRatio,
                originalElement: this.element,
                _proportionallyResizeElements: [],
                _helper: e.helper || e.ghost || e.animate ? e.helper || "ui-resizable-helper" : null
            }), this.element[0].nodeName.match(/^(canvas|textarea|input|select|button|img)$/i) && (this.element.wrap(b("<div class='ui-wrapper' style='overflow: hidden;'></div>").css({
                position: this.element.css("position"),
                width: this.element.outerWidth(),
                height: this.element.outerHeight(),
                top: this.element.css("top"),
                left: this.element.css("left")
            })), this.element = this.element.parent().data("ui-resizable", this.element.resizable("instance")), this.elementIsWrapper = !0, t = {
                marginTop: this.originalElement.css("marginTop"),
                marginRight: this.originalElement.css("marginRight"),
                marginBottom: this.originalElement.css("marginBottom"),
                marginLeft: this.originalElement.css("marginLeft")
            }, this.element.css(t), this.originalElement.css("margin", 0), this.originalResizeStyle = this.originalElement.css("resize"), this.originalElement.css("resize", "none"), this._proportionallyResizeElements.push(this.originalElement.css({
                position: "static",
                zoom: 1,
                display: "block"
            })), this.originalElement.css(t), this._proportionallyResize()), this._setupHandles(), e.autoHide && b(this.element).on("mouseenter", function () {
                e.disabled || (i._removeClass("ui-resizable-autohide"), i._handles.show())
            }).on("mouseleave", function () {
                e.disabled || i.resizing || (i._addClass("ui-resizable-autohide"), i._handles.hide())
            }), this._mouseInit()
        },
        _destroy: function () {
            this._mouseDestroy();

            function t(t) {
                b(t).removeData("resizable").removeData("ui-resizable").off(".resizable").find(".ui-resizable-handle").remove()
            }

            var e;
            return this.elementIsWrapper && (t(this.element), e = this.element, this.originalElement.css({
                position: e.css("position"),
                width: e.outerWidth(),
                height: e.outerHeight(),
                top: e.css("top"),
                left: e.css("left")
            }).insertAfter(e), e.remove()), this.originalElement.css("resize", this.originalResizeStyle), t(this.originalElement), this
        },
        _setOption: function (t, e) {
            this._super(t, e), "handles" === t && (this._removeHandles(), this._setupHandles())
        },
        _setupHandles: function () {
            var t, e, i, s, n, o = this.options, r = this;
            if (this.handles = o.handles || (b(".ui-resizable-handle", this.element).length ? {
                n: ".ui-resizable-n",
                e: ".ui-resizable-e",
                s: ".ui-resizable-s",
                w: ".ui-resizable-w",
                se: ".ui-resizable-se",
                sw: ".ui-resizable-sw",
                ne: ".ui-resizable-ne",
                nw: ".ui-resizable-nw"
            } : "e,s,se"), this._handles = b(), this.handles.constructor === String) for ("all" === this.handles && (this.handles = "n,e,s,w,se,sw,ne,nw"), i = this.handles.split(","), this.handles = {}, e = 0; e < i.length; e++) s = "ui-resizable-" + (t = b.trim(i[e])), n = b("<div>"), this._addClass(n, "ui-resizable-handle " + s), n.css({zIndex: o.zIndex}), this.handles[t] = ".ui-resizable-" + t, this.element.append(n);
            this._renderAxis = function (t) {
                var e, i, s;
                for (e in t = t || this.element, this.handles) this.handles[e].constructor === String ? this.handles[e] = this.element.children(this.handles[e]).first().show() : (this.handles[e].jquery || this.handles[e].nodeType) && (this.handles[e] = b(this.handles[e]), this._on(this.handles[e], {mousedown: r._mouseDown})), this.elementIsWrapper && this.originalElement[0].nodeName.match(/^(textarea|input|select|button)$/i) && (i = b(this.handles[e], this.element), s = /sw|ne|nw|se|n|s/.test(e) ? i.outerHeight() : i.outerWidth(), i = ["padding", /ne|nw|n/.test(e) ? "Top" : /se|sw|s/.test(e) ? "Bottom" : /^e$/.test(e) ? "Right" : "Left"].join(""), t.css(i, s), this._proportionallyResize()), this._handles = this._handles.add(this.handles[e])
            }, this._renderAxis(this.element), this._handles = this._handles.add(this.element.find(".ui-resizable-handle")), this._handles.disableSelection(), this._handles.on("mouseover", function () {
                r.resizing || (this.className && (n = this.className.match(/ui-resizable-(se|sw|ne|nw|n|e|s|w)/i)), r.axis = n && n[1] ? n[1] : "se")
            }), o.autoHide && (this._handles.hide(), this._addClass("ui-resizable-autohide"))
        },
        _removeHandles: function () {
            this._handles.remove()
        },
        _mouseCapture: function (t) {
            var e, i, s = !1;
            for (e in this.handles) (i = b(this.handles[e])[0]) !== t.target && !b.contains(i, t.target) || (s = !0);
            return !this.options.disabled && s
        },
        _mouseStart: function (t) {
            var e, i, s = this.options, n = this.element;
            return this.resizing = !0, this._renderProxy(), e = this._num(this.helper.css("left")), i = this._num(this.helper.css("top")), s.containment && (e += b(s.containment).scrollLeft() || 0, i += b(s.containment).scrollTop() || 0), this.offset = this.helper.offset(), this.position = {
                left: e,
                top: i
            }, this.size = this._helper ? {
                width: this.helper.width(),
                height: this.helper.height()
            } : {width: n.width(), height: n.height()}, this.originalSize = this._helper ? {
                width: n.outerWidth(),
                height: n.outerHeight()
            } : {width: n.width(), height: n.height()}, this.sizeDiff = {
                width: n.outerWidth() - n.width(),
                height: n.outerHeight() - n.height()
            }, this.originalPosition = {left: e, top: i}, this.originalMousePosition = {
                left: t.pageX,
                top: t.pageY
            }, this.aspectRatio = "number" == typeof s.aspectRatio ? s.aspectRatio : this.originalSize.width / this.originalSize.height || 1, s = b(".ui-resizable-" + this.axis).css("cursor"), b("body").css("cursor", "auto" === s ? this.axis + "-resize" : s), this._addClass("ui-resizable-resizing"), this._propagate("start", t), !0
        },
        _mouseDrag: function (t) {
            var e = this.originalMousePosition, i = this.axis, s = t.pageX - e.left || 0, e = t.pageY - e.top || 0,
                i = this._change[i];
            return this._updatePrevProperties(), i && (e = i.apply(this, [t, s, e]), this._updateVirtualBoundaries(t.shiftKey), (this._aspectRatio || t.shiftKey) && (e = this._updateRatio(e, t)), e = this._respectSize(e, t), this._updateCache(e), this._propagate("resize", t), e = this._applyChanges(), !this._helper && this._proportionallyResizeElements.length && this._proportionallyResize(), b.isEmptyObject(e) || (this._updatePrevProperties(), this._trigger("resize", t, this.ui()), this._applyChanges())), !1
        },
        _mouseStop: function (t) {
            this.resizing = !1;
            var e, i, s, n = this.options, o = this;
            return this._helper && (s = (e = (i = this._proportionallyResizeElements).length && /textarea/i.test(i[0].nodeName)) && this._hasScroll(i[0], "left") ? 0 : o.sizeDiff.height, i = e ? 0 : o.sizeDiff.width, e = {
                width: o.helper.width() - i,
                height: o.helper.height() - s
            }, i = parseFloat(o.element.css("left")) + (o.position.left - o.originalPosition.left) || null, s = parseFloat(o.element.css("top")) + (o.position.top - o.originalPosition.top) || null, n.animate || this.element.css(b.extend(e, {
                top: s,
                left: i
            })), o.helper.height(o.size.height), o.helper.width(o.size.width), this._helper && !n.animate && this._proportionallyResize()), b("body").css("cursor", "auto"), this._removeClass("ui-resizable-resizing"), this._propagate("stop", t), this._helper && this.helper.remove(), !1
        },
        _updatePrevProperties: function () {
            this.prevPosition = {
                top: this.position.top,
                left: this.position.left
            }, this.prevSize = {width: this.size.width, height: this.size.height}
        },
        _applyChanges: function () {
            var t = {};
            return this.position.top !== this.prevPosition.top && (t.top = this.position.top + "px"), this.position.left !== this.prevPosition.left && (t.left = this.position.left + "px"), this.size.width !== this.prevSize.width && (t.width = this.size.width + "px"), this.size.height !== this.prevSize.height && (t.height = this.size.height + "px"), this.helper.css(t), t
        },
        _updateVirtualBoundaries: function (t) {
            var e, i, s = this.options, n = {
                minWidth: this._isNumber(s.minWidth) ? s.minWidth : 0,
                maxWidth: this._isNumber(s.maxWidth) ? s.maxWidth : 1 / 0,
                minHeight: this._isNumber(s.minHeight) ? s.minHeight : 0,
                maxHeight: this._isNumber(s.maxHeight) ? s.maxHeight : 1 / 0
            };
            (this._aspectRatio || t) && (e = n.minHeight * this.aspectRatio, i = n.minWidth / this.aspectRatio, s = n.maxHeight * this.aspectRatio, t = n.maxWidth / this.aspectRatio, e > n.minWidth && (n.minWidth = e), i > n.minHeight && (n.minHeight = i), s < n.maxWidth && (n.maxWidth = s), t < n.maxHeight && (n.maxHeight = t)), this._vBoundaries = n
        },
        _updateCache: function (t) {
            this.offset = this.helper.offset(), this._isNumber(t.left) && (this.position.left = t.left), this._isNumber(t.top) && (this.position.top = t.top), this._isNumber(t.height) && (this.size.height = t.height), this._isNumber(t.width) && (this.size.width = t.width)
        },
        _updateRatio: function (t) {
            var e = this.position, i = this.size, s = this.axis;
            return this._isNumber(t.height) ? t.width = t.height * this.aspectRatio : this._isNumber(t.width) && (t.height = t.width / this.aspectRatio), "sw" === s && (t.left = e.left + (i.width - t.width), t.top = null), "nw" === s && (t.top = e.top + (i.height - t.height), t.left = e.left + (i.width - t.width)), t
        },
        _respectSize: function (t) {
            var e = this._vBoundaries, i = this.axis, s = this._isNumber(t.width) && e.maxWidth && e.maxWidth < t.width,
                n = this._isNumber(t.height) && e.maxHeight && e.maxHeight < t.height,
                o = this._isNumber(t.width) && e.minWidth && e.minWidth > t.width,
                r = this._isNumber(t.height) && e.minHeight && e.minHeight > t.height,
                h = this.originalPosition.left + this.originalSize.width,
                a = this.originalPosition.top + this.originalSize.height, l = /sw|nw|w/.test(i), i = /nw|ne|n/.test(i);
            return o && (t.width = e.minWidth), r && (t.height = e.minHeight), s && (t.width = e.maxWidth), n && (t.height = e.maxHeight), o && l && (t.left = h - e.minWidth), s && l && (t.left = h - e.maxWidth), r && i && (t.top = a - e.minHeight), n && i && (t.top = a - e.maxHeight), t.width || t.height || t.left || !t.top ? t.width || t.height || t.top || !t.left || (t.left = null) : t.top = null, t
        },
        _getPaddingPlusBorderDimensions: function (t) {
            for (var e = 0, i = [], s = [t.css("borderTopWidth"), t.css("borderRightWidth"), t.css("borderBottomWidth"), t.css("borderLeftWidth")], n = [t.css("paddingTop"), t.css("paddingRight"), t.css("paddingBottom"), t.css("paddingLeft")]; e < 4; e++) i[e] = parseFloat(s[e]) || 0, i[e] += parseFloat(n[e]) || 0;
            return {height: i[0] + i[2], width: i[1] + i[3]}
        },
        _proportionallyResize: function () {
            if (this._proportionallyResizeElements.length) for (var t, e = 0, i = this.helper || this.element; e < this._proportionallyResizeElements.length; e++) t = this._proportionallyResizeElements[e], this.outerDimensions || (this.outerDimensions = this._getPaddingPlusBorderDimensions(t)), t.css({
                height: i.height() - this.outerDimensions.height || 0,
                width: i.width() - this.outerDimensions.width || 0
            })
        },
        _renderProxy: function () {
            var t = this.element, e = this.options;
            this.elementOffset = t.offset(), this._helper ? (this.helper = this.helper || b("<div style='overflow:hidden;'></div>"), this._addClass(this.helper, this._helper), this.helper.css({
                width: this.element.outerWidth(),
                height: this.element.outerHeight(),
                position: "absolute",
                left: this.elementOffset.left + "px",
                top: this.elementOffset.top + "px",
                zIndex: ++e.zIndex
            }), this.helper.appendTo("body").disableSelection()) : this.helper = this.element
        },
        _change: {
            e: function (t, e) {
                return {width: this.originalSize.width + e}
            }, w: function (t, e) {
                var i = this.originalSize;
                return {left: this.originalPosition.left + e, width: i.width - e}
            }, n: function (t, e, i) {
                var s = this.originalSize;
                return {top: this.originalPosition.top + i, height: s.height - i}
            }, s: function (t, e, i) {
                return {height: this.originalSize.height + i}
            }, se: function (t, e, i) {
                return b.extend(this._change.s.apply(this, arguments), this._change.e.apply(this, [t, e, i]))
            }, sw: function (t, e, i) {
                return b.extend(this._change.s.apply(this, arguments), this._change.w.apply(this, [t, e, i]))
            }, ne: function (t, e, i) {
                return b.extend(this._change.n.apply(this, arguments), this._change.e.apply(this, [t, e, i]))
            }, nw: function (t, e, i) {
                return b.extend(this._change.n.apply(this, arguments), this._change.w.apply(this, [t, e, i]))
            }
        },
        _propagate: function (t, e) {
            b.ui.plugin.call(this, t, [e, this.ui()]), "resize" !== t && this._trigger(t, e, this.ui())
        },
        plugins: {},
        ui: function () {
            return {
                originalElement: this.originalElement,
                element: this.element,
                helper: this.helper,
                position: this.position,
                size: this.size,
                originalSize: this.originalSize,
                originalPosition: this.originalPosition
            }
        }
    }), b.ui.plugin.add("resizable", "animate", {
        stop: function (e) {
            var i = b(this).resizable("instance"), t = i.options, s = i._proportionallyResizeElements,
                n = s.length && /textarea/i.test(s[0].nodeName),
                o = n && i._hasScroll(s[0], "left") ? 0 : i.sizeDiff.height, r = n ? 0 : i.sizeDiff.width,
                n = {width: i.size.width - r, height: i.size.height - o},
                r = parseFloat(i.element.css("left")) + (i.position.left - i.originalPosition.left) || null,
                o = parseFloat(i.element.css("top")) + (i.position.top - i.originalPosition.top) || null;
            i.element.animate(b.extend(n, o && r ? {top: o, left: r} : {}), {
                duration: t.animateDuration,
                easing: t.animateEasing,
                step: function () {
                    var t = {
                        width: parseFloat(i.element.css("width")),
                        height: parseFloat(i.element.css("height")),
                        top: parseFloat(i.element.css("top")),
                        left: parseFloat(i.element.css("left"))
                    };
                    s && s.length && b(s[0]).css({
                        width: t.width,
                        height: t.height
                    }), i._updateCache(t), i._propagate("resize", e)
                }
            })
        }
    }), b.ui.plugin.add("resizable", "containment", {
        start: function () {
            var i, s, n = b(this).resizable("instance"), t = n.options, e = n.element, o = t.containment,
                r = o instanceof b ? o.get(0) : /parent/.test(o) ? e.parent().get(0) : o;
            r && (n.containerElement = b(r), /document/.test(o) || o === document ? (n.containerOffset = {
                left: 0,
                top: 0
            }, n.containerPosition = {left: 0, top: 0}, n.parentData = {
                element: b(document),
                left: 0,
                top: 0,
                width: b(document).width(),
                height: b(document).height() || document.body.parentNode.scrollHeight
            }) : (i = b(r), s = [], b(["Top", "Right", "Left", "Bottom"]).each(function (t, e) {
                s[t] = n._num(i.css("padding" + e))
            }), n.containerOffset = i.offset(), n.containerPosition = i.position(), n.containerSize = {
                height: i.innerHeight() - s[3],
                width: i.innerWidth() - s[1]
            }, t = n.containerOffset, e = n.containerSize.height, o = n.containerSize.width, o = n._hasScroll(r, "left") ? r.scrollWidth : o, e = n._hasScroll(r) ? r.scrollHeight : e, n.parentData = {
                element: r,
                left: t.left,
                top: t.top,
                width: o,
                height: e
            }))
        }, resize: function (t) {
            var e = b(this).resizable("instance"), i = e.options, s = e.containerOffset, n = e.position,
                o = e._aspectRatio || t.shiftKey, r = {top: 0, left: 0}, h = e.containerElement, t = !0;
            h[0] !== document && /static/.test(h.css("position")) && (r = s), n.left < (e._helper ? s.left : 0) && (e.size.width = e.size.width + (e._helper ? e.position.left - s.left : e.position.left - r.left), o && (e.size.height = e.size.width / e.aspectRatio, t = !1), e.position.left = i.helper ? s.left : 0), n.top < (e._helper ? s.top : 0) && (e.size.height = e.size.height + (e._helper ? e.position.top - s.top : e.position.top), o && (e.size.width = e.size.height * e.aspectRatio, t = !1), e.position.top = e._helper ? s.top : 0), i = e.containerElement.get(0) === e.element.parent().get(0), n = /relative|absolute/.test(e.containerElement.css("position")), i && n ? (e.offset.left = e.parentData.left + e.position.left, e.offset.top = e.parentData.top + e.position.top) : (e.offset.left = e.element.offset().left, e.offset.top = e.element.offset().top), n = Math.abs(e.sizeDiff.width + (e._helper ? e.offset.left - r.left : e.offset.left - s.left)), s = Math.abs(e.sizeDiff.height + (e._helper ? e.offset.top - r.top : e.offset.top - s.top)), n + e.size.width >= e.parentData.width && (e.size.width = e.parentData.width - n, o && (e.size.height = e.size.width / e.aspectRatio, t = !1)), s + e.size.height >= e.parentData.height && (e.size.height = e.parentData.height - s, o && (e.size.width = e.size.height * e.aspectRatio, t = !1)), t || (e.position.left = e.prevPosition.left, e.position.top = e.prevPosition.top, e.size.width = e.prevSize.width, e.size.height = e.prevSize.height)
        }, stop: function () {
            var t = b(this).resizable("instance"), e = t.options, i = t.containerOffset, s = t.containerPosition,
                n = t.containerElement, o = b(t.helper), r = o.offset(), h = o.outerWidth() - t.sizeDiff.width,
                o = o.outerHeight() - t.sizeDiff.height;
            t._helper && !e.animate && /relative/.test(n.css("position")) && b(this).css({
                left: r.left - s.left - i.left,
                width: h,
                height: o
            }), t._helper && !e.animate && /static/.test(n.css("position")) && b(this).css({
                left: r.left - s.left - i.left,
                width: h,
                height: o
            })
        }
    }), b.ui.plugin.add("resizable", "alsoResize", {
        start: function () {
            var t = b(this).resizable("instance").options;
            b(t.alsoResize).each(function () {
                var t = b(this);
                t.data("ui-resizable-alsoresize", {
                    width: parseFloat(t.width()),
                    height: parseFloat(t.height()),
                    left: parseFloat(t.css("left")),
                    top: parseFloat(t.css("top"))
                })
            })
        }, resize: function (t, i) {
            var e = b(this).resizable("instance"), s = e.options, n = e.originalSize, o = e.originalPosition, r = {
                height: e.size.height - n.height || 0,
                width: e.size.width - n.width || 0,
                top: e.position.top - o.top || 0,
                left: e.position.left - o.left || 0
            };
            b(s.alsoResize).each(function () {
                var t = b(this), s = b(this).data("ui-resizable-alsoresize"), n = {},
                    e = t.parents(i.originalElement[0]).length ? ["width", "height"] : ["width", "height", "top", "left"];
                b.each(e, function (t, e) {
                    var i = (s[e] || 0) + (r[e] || 0);
                    i && 0 <= i && (n[e] = i || null)
                }), t.css(n)
            })
        }, stop: function () {
            b(this).removeData("ui-resizable-alsoresize")
        }
    }), b.ui.plugin.add("resizable", "ghost", {
        start: function () {
            var t = b(this).resizable("instance"), e = t.size;
            t.ghost = t.originalElement.clone(), t.ghost.css({
                opacity: .25,
                display: "block",
                position: "relative",
                height: e.height,
                width: e.width,
                margin: 0,
                left: 0,
                top: 0
            }), t._addClass(t.ghost, "ui-resizable-ghost"), !1 !== b.uiBackCompat && "string" == typeof t.options.ghost && t.ghost.addClass(this.options.ghost), t.ghost.appendTo(t.helper)
        }, resize: function () {
            var t = b(this).resizable("instance");
            t.ghost && t.ghost.css({position: "relative", height: t.size.height, width: t.size.width})
        }, stop: function () {
            var t = b(this).resizable("instance");
            t.ghost && t.helper && t.helper.get(0).removeChild(t.ghost.get(0))
        }
    }), b.ui.plugin.add("resizable", "grid", {
        resize: function () {
            var t, e = b(this).resizable("instance"), i = e.options, s = e.size, n = e.originalSize,
                o = e.originalPosition, r = e.axis, h = "number" == typeof i.grid ? [i.grid, i.grid] : i.grid,
                a = h[0] || 1, l = h[1] || 1, c = Math.round((s.width - n.width) / a) * a,
                p = Math.round((s.height - n.height) / l) * l, u = n.width + c, d = n.height + p,
                f = i.maxWidth && i.maxWidth < u, g = i.maxHeight && i.maxHeight < d, m = i.minWidth && i.minWidth > u,
                s = i.minHeight && i.minHeight > d;
            i.grid = h, m && (u += a), s && (d += l), f && (u -= a), g && (d -= l), /^(se|s|e)$/.test(r) ? (e.size.width = u, e.size.height = d) : /^(ne)$/.test(r) ? (e.size.width = u, e.size.height = d, e.position.top = o.top - p) : /^(sw)$/.test(r) ? (e.size.width = u, e.size.height = d, e.position.left = o.left - c) : ((d - l <= 0 || u - a <= 0) && (t = e._getPaddingPlusBorderDimensions(this)), 0 < d - l ? (e.size.height = d, e.position.top = o.top - p) : (d = l - t.height, e.size.height = d, e.position.top = o.top + n.height - d), 0 < u - a ? (e.size.width = u, e.position.left = o.left - c) : (u = a - t.width, e.size.width = u, e.position.left = o.left + n.width - u))
        }
    });
    b.ui.resizable, b.widget("ui.selectable", b.ui.mouse, {
        version: "1.12.1",
        options: {
            appendTo: "body",
            autoRefresh: !0,
            distance: 0,
            filter: "*",
            tolerance: "touch",
            selected: null,
            selecting: null,
            start: null,
            stop: null,
            unselected: null,
            unselecting: null
        },
        _create: function () {
            var i = this;
            this._addClass("ui-selectable"), this.dragged = !1, this.refresh = function () {
                i.elementPos = b(i.element[0]).offset(), i.selectees = b(i.options.filter, i.element[0]), i._addClass(i.selectees, "ui-selectee"), i.selectees.each(function () {
                    var t = b(this), e = t.offset(),
                        e = {left: e.left - i.elementPos.left, top: e.top - i.elementPos.top};
                    b.data(this, "selectable-item", {
                        element: this,
                        $element: t,
                        left: e.left,
                        top: e.top,
                        right: e.left + t.outerWidth(),
                        bottom: e.top + t.outerHeight(),
                        startselected: !1,
                        selected: t.hasClass("ui-selected"),
                        selecting: t.hasClass("ui-selecting"),
                        unselecting: t.hasClass("ui-unselecting")
                    })
                })
            }, this.refresh(), this._mouseInit(), this.helper = b("<div>"), this._addClass(this.helper, "ui-selectable-helper")
        },
        _destroy: function () {
            this.selectees.removeData("selectable-item"), this._mouseDestroy()
        },
        _mouseStart: function (i) {
            var s = this, t = this.options;
            this.opos = [i.pageX, i.pageY], this.elementPos = b(this.element[0]).offset(), this.options.disabled || (this.selectees = b(t.filter, this.element[0]), this._trigger("start", i), b(t.appendTo).append(this.helper), this.helper.css({
                left: i.pageX,
                top: i.pageY,
                width: 0,
                height: 0
            }), t.autoRefresh && this.refresh(), this.selectees.filter(".ui-selected").each(function () {
                var t = b.data(this, "selectable-item");
                t.startselected = !0, i.metaKey || i.ctrlKey || (s._removeClass(t.$element, "ui-selected"), t.selected = !1, s._addClass(t.$element, "ui-unselecting"), t.unselecting = !0, s._trigger("unselecting", i, {unselecting: t.element}))
            }), b(i.target).parents().addBack().each(function () {
                var t, e = b.data(this, "selectable-item");
                if (e) return t = !i.metaKey && !i.ctrlKey || !e.$element.hasClass("ui-selected"), s._removeClass(e.$element, t ? "ui-unselecting" : "ui-selected")._addClass(e.$element, t ? "ui-selecting" : "ui-unselecting"), e.unselecting = !t, e.selecting = t, (e.selected = t) ? s._trigger("selecting", i, {selecting: e.element}) : s._trigger("unselecting", i, {unselecting: e.element}), !1
            }))
        },
        _mouseDrag: function (s) {
            if (this.dragged = !0, !this.options.disabled) {
                var t, n = this, o = this.options, r = this.opos[0], h = this.opos[1], a = s.pageX, l = s.pageY;
                return a < r && (t = a, a = r, r = t), l < h && (t = l, l = h, h = t), this.helper.css({
                    left: r,
                    top: h,
                    width: a - r,
                    height: l - h
                }), this.selectees.each(function () {
                    var t = b.data(this, "selectable-item"), e = !1, i = {};
                    t && t.element !== n.element[0] && (i.left = t.left + n.elementPos.left, i.right = t.right + n.elementPos.left, i.top = t.top + n.elementPos.top, i.bottom = t.bottom + n.elementPos.top, "touch" === o.tolerance ? e = !(i.left > a || i.right < r || i.top > l || i.bottom < h) : "fit" === o.tolerance && (e = i.left > r && i.right < a && i.top > h && i.bottom < l), e ? (t.selected && (n._removeClass(t.$element, "ui-selected"), t.selected = !1), t.unselecting && (n._removeClass(t.$element, "ui-unselecting"), t.unselecting = !1), t.selecting || (n._addClass(t.$element, "ui-selecting"), t.selecting = !0, n._trigger("selecting", s, {selecting: t.element}))) : (t.selecting && ((s.metaKey || s.ctrlKey) && t.startselected ? (n._removeClass(t.$element, "ui-selecting"), t.selecting = !1, n._addClass(t.$element, "ui-selected"), t.selected = !0) : (n._removeClass(t.$element, "ui-selecting"), t.selecting = !1, t.startselected && (n._addClass(t.$element, "ui-unselecting"), t.unselecting = !0), n._trigger("unselecting", s, {unselecting: t.element}))), t.selected && (s.metaKey || s.ctrlKey || t.startselected || (n._removeClass(t.$element, "ui-selected"), t.selected = !1, n._addClass(t.$element, "ui-unselecting"), t.unselecting = !0, n._trigger("unselecting", s, {unselecting: t.element})))))
                }), !1
            }
        },
        _mouseStop: function (e) {
            var i = this;
            return this.dragged = !1, b(".ui-unselecting", this.element[0]).each(function () {
                var t = b.data(this, "selectable-item");
                i._removeClass(t.$element, "ui-unselecting"), t.unselecting = !1, t.startselected = !1, i._trigger("unselected", e, {unselected: t.element})
            }), b(".ui-selecting", this.element[0]).each(function () {
                var t = b.data(this, "selectable-item");
                i._removeClass(t.$element, "ui-selecting")._addClass(t.$element, "ui-selected"), t.selecting = !1, t.selected = !0, t.startselected = !0, i._trigger("selected", e, {selected: t.element})
            }), this._trigger("stop", e), this.helper.remove(), !1
        }
    }), b.widget("ui.sortable", b.ui.mouse, {
        version: "1.12.1",
        widgetEventPrefix: "sort",
        ready: !1,
        options: {
            appendTo: "parent",
            axis: !1,
            connectWith: !1,
            containment: !1,
            cursor: "auto",
            cursorAt: !1,
            dropOnEmpty: !0,
            forcePlaceholderSize: !1,
            forceHelperSize: !1,
            grid: !1,
            handle: !1,
            helper: "original",
            items: "> *",
            opacity: !1,
            placeholder: !1,
            revert: !1,
            scroll: !0,
            scrollSensitivity: 20,
            scrollSpeed: 20,
            scope: "default",
            tolerance: "intersect",
            zIndex: 1e3,
            activate: null,
            beforeStop: null,
            change: null,
            deactivate: null,
            out: null,
            over: null,
            receive: null,
            remove: null,
            sort: null,
            start: null,
            stop: null,
            update: null
        },
        _isOverAxis: function (t, e, i) {
            return e <= t && t < e + i
        },
        _isFloating: function (t) {
            return /left|right/.test(t.css("float")) || /inline|table-cell/.test(t.css("display"))
        },
        _create: function () {
            this.containerCache = {}, this._addClass("ui-sortable"), this.refresh(), this.offset = this.element.offset(), this._mouseInit(), this._setHandleClassName(), this.ready = !0
        },
        _setOption: function (t, e) {
            this._super(t, e), "handle" === t && this._setHandleClassName()
        },
        _setHandleClassName: function () {
            var t = this;
            this._removeClass(this.element.find(".ui-sortable-handle"), "ui-sortable-handle"), b.each(this.items, function () {
                t._addClass(this.instance.options.handle ? this.item.find(this.instance.options.handle) : this.item, "ui-sortable-handle")
            })
        },
        _destroy: function () {
            this._mouseDestroy();
            for (var t = this.items.length - 1; 0 <= t; t--) this.items[t].item.removeData(this.widgetName + "-item");
            return this
        },
        _mouseCapture: function (t, e) {
            var i = null, s = !1, n = this;
            return !this.reverting && (!this.options.disabled && "static" !== this.options.type && (this._refreshItems(t), b(t.target).parents().each(function () {
                if (b.data(this, n.widgetName + "-item") === n) return i = b(this), !1
            }), b.data(t.target, n.widgetName + "-item") === n && (i = b(t.target)), !!i && (!(this.options.handle && !e && (b(this.options.handle, i).find("*").addBack().each(function () {
                this === t.target && (s = !0)
            }), !s)) && (this.currentItem = i, this._removeCurrentsFromItems(), !0))))
        },
        _mouseStart: function (t, e, i) {
            var s, n, o = this.options;
            if ((this.currentContainer = this).refreshPositions(), this.helper = this._createHelper(t), this._cacheHelperProportions(), this._cacheMargins(), this.scrollParent = this.helper.scrollParent(), this.offset = this.currentItem.offset(), this.offset = {
                top: this.offset.top - this.margins.top,
                left: this.offset.left - this.margins.left
            }, b.extend(this.offset, {
                click: {left: t.pageX - this.offset.left, top: t.pageY - this.offset.top},
                parent: this._getParentOffset(),
                relative: this._getRelativeOffset()
            }), this.helper.css("position", "absolute"), this.cssPosition = this.helper.css("position"), this.originalPosition = this._generatePosition(t), this.originalPageX = t.pageX, this.originalPageY = t.pageY, o.cursorAt && this._adjustOffsetFromHelper(o.cursorAt), this.domPosition = {
                prev: this.currentItem.prev()[0],
                parent: this.currentItem.parent()[0]
            }, this.helper[0] !== this.currentItem[0] && this.currentItem.hide(), this._createPlaceholder(), o.containment && this._setContainment(), o.cursor && "auto" !== o.cursor && (n = this.document.find("body"), this.storedCursor = n.css("cursor"), n.css("cursor", o.cursor), this.storedStylesheet = b("<style>*{ cursor: " + o.cursor + " !important; }</style>").appendTo(n)), o.opacity && (this.helper.css("opacity") && (this._storedOpacity = this.helper.css("opacity")), this.helper.css("opacity", o.opacity)), o.zIndex && (this.helper.css("zIndex") && (this._storedZIndex = this.helper.css("zIndex")), this.helper.css("zIndex", o.zIndex)), this.scrollParent[0] !== this.document[0] && "HTML" !== this.scrollParent[0].tagName && (this.overflowOffset = this.scrollParent.offset()), this._trigger("start", t, this._uiHash()), this._preserveHelperProportions || this._cacheHelperProportions(), !i) for (s = this.containers.length - 1; 0 <= s; s--) this.containers[s]._trigger("activate", t, this._uiHash(this));
            return b.ui.ddmanager && (b.ui.ddmanager.current = this), b.ui.ddmanager && !o.dropBehaviour && b.ui.ddmanager.prepareOffsets(this, t), this.dragging = !0, this._addClass(this.helper, "ui-sortable-helper"), this._mouseDrag(t), !0
        },
        _mouseDrag: function (t) {
            var e, i, s, n, o = this.options, r = !1;
            for (this.position = this._generatePosition(t), this.positionAbs = this._convertPositionTo("absolute"), this.lastPositionAbs || (this.lastPositionAbs = this.positionAbs), this.options.scroll && (this.scrollParent[0] !== this.document[0] && "HTML" !== this.scrollParent[0].tagName ? (this.overflowOffset.top + this.scrollParent[0].offsetHeight - t.pageY < o.scrollSensitivity ? this.scrollParent[0].scrollTop = r = this.scrollParent[0].scrollTop + o.scrollSpeed : t.pageY - this.overflowOffset.top < o.scrollSensitivity && (this.scrollParent[0].scrollTop = r = this.scrollParent[0].scrollTop - o.scrollSpeed), this.overflowOffset.left + this.scrollParent[0].offsetWidth - t.pageX < o.scrollSensitivity ? this.scrollParent[0].scrollLeft = r = this.scrollParent[0].scrollLeft + o.scrollSpeed : t.pageX - this.overflowOffset.left < o.scrollSensitivity && (this.scrollParent[0].scrollLeft = r = this.scrollParent[0].scrollLeft - o.scrollSpeed)) : (t.pageY - this.document.scrollTop() < o.scrollSensitivity ? r = this.document.scrollTop(this.document.scrollTop() - o.scrollSpeed) : this.window.height() - (t.pageY - this.document.scrollTop()) < o.scrollSensitivity && (r = this.document.scrollTop(this.document.scrollTop() + o.scrollSpeed)), t.pageX - this.document.scrollLeft() < o.scrollSensitivity ? r = this.document.scrollLeft(this.document.scrollLeft() - o.scrollSpeed) : this.window.width() - (t.pageX - this.document.scrollLeft()) < o.scrollSensitivity && (r = this.document.scrollLeft(this.document.scrollLeft() + o.scrollSpeed))), !1 !== r && b.ui.ddmanager && !o.dropBehaviour && b.ui.ddmanager.prepareOffsets(this, t)), this.positionAbs = this._convertPositionTo("absolute"), this.options.axis && "y" === this.options.axis || (this.helper[0].style.left = this.position.left + "px"), this.options.axis && "x" === this.options.axis || (this.helper[0].style.top = this.position.top + "px"), e = this.items.length - 1; 0 <= e; e--) if (s = (i = this.items[e]).item[0], (n = this._intersectsWithPointer(i)) && i.instance === this.currentContainer && !(s === this.currentItem[0] || this.placeholder[1 === n ? "next" : "prev"]()[0] === s || b.contains(this.placeholder[0], s) || "semi-dynamic" === this.options.type && b.contains(this.element[0], s))) {
                if (this.direction = 1 === n ? "down" : "up", "pointer" !== this.options.tolerance && !this._intersectsWithSides(i)) break;
                this._rearrange(t, i), this._trigger("change", t, this._uiHash());
                break
            }
            return this._contactContainers(t), b.ui.ddmanager && b.ui.ddmanager.drag(this, t), this._trigger("sort", t, this._uiHash()), this.lastPositionAbs = this.positionAbs, !1
        },
        _mouseStop: function (t, e) {
            var i, s, n, o;
            if (t) return b.ui.ddmanager && !this.options.dropBehaviour && b.ui.ddmanager.drop(this, t), this.options.revert ? (s = (i = this).placeholder.offset(), o = {}, (n = this.options.axis) && "x" !== n || (o.left = s.left - this.offset.parent.left - this.margins.left + (this.offsetParent[0] === this.document[0].body ? 0 : this.offsetParent[0].scrollLeft)), n && "y" !== n || (o.top = s.top - this.offset.parent.top - this.margins.top + (this.offsetParent[0] === this.document[0].body ? 0 : this.offsetParent[0].scrollTop)), this.reverting = !0, b(this.helper).animate(o, parseInt(this.options.revert, 10) || 500, function () {
                i._clear(t)
            })) : this._clear(t, e), !1
        },
        cancel: function () {
            if (this.dragging) {
                this._mouseUp(new b.Event("mouseup", {target: null})), "original" === this.options.helper ? (this.currentItem.css(this._storedCSS), this._removeClass(this.currentItem, "ui-sortable-helper")) : this.currentItem.show();
                for (var t = this.containers.length - 1; 0 <= t; t--) this.containers[t]._trigger("deactivate", null, this._uiHash(this)), this.containers[t].containerCache.over && (this.containers[t]._trigger("out", null, this._uiHash(this)), this.containers[t].containerCache.over = 0)
            }
            return this.placeholder && (this.placeholder[0].parentNode && this.placeholder[0].parentNode.removeChild(this.placeholder[0]), "original" !== this.options.helper && this.helper && this.helper[0].parentNode && this.helper.remove(), b.extend(this, {
                helper: null,
                dragging: !1,
                reverting: !1,
                _noFinalSort: null
            }), this.domPosition.prev ? b(this.domPosition.prev).after(this.currentItem) : b(this.domPosition.parent).prepend(this.currentItem)), this
        },
        serialize: function (e) {
            var t = this._getItemsAsjQuery(e && e.connected), i = [];
            return e = e || {}, b(t).each(function () {
                var t = (b(e.item || this).attr(e.attribute || "id") || "").match(e.expression || /(.+)[\-=_](.+)/);
                t && i.push((e.key || t[1] + "[]") + "=" + (e.key && e.expression ? t[1] : t[2]))
            }), !i.length && e.key && i.push(e.key + "="), i.join("&")
        },
        toArray: function (t) {
            var e = this._getItemsAsjQuery(t && t.connected), i = [];
            return t = t || {}, e.each(function () {
                i.push(b(t.item || this).attr(t.attribute || "id") || "")
            }), i
        },
        _intersectsWith: function (t) {
            var e = this.positionAbs.left, i = e + this.helperProportions.width, s = this.positionAbs.top,
                n = s + this.helperProportions.height, o = t.left, r = o + t.width, h = t.top, a = h + t.height,
                l = this.offset.click.top, c = this.offset.click.left,
                l = "x" === this.options.axis || h < s + l && s + l < a,
                c = "y" === this.options.axis || o < e + c && e + c < r, c = l && c;
            return "pointer" === this.options.tolerance || this.options.forcePointerForContainers || "pointer" !== this.options.tolerance && this.helperProportions[this.floating ? "width" : "height"] > t[this.floating ? "width" : "height"] ? c : o < e + this.helperProportions.width / 2 && i - this.helperProportions.width / 2 < r && h < s + this.helperProportions.height / 2 && n - this.helperProportions.height / 2 < a
        },
        _intersectsWithPointer: function (t) {
            var e = "x" === this.options.axis || this._isOverAxis(this.positionAbs.top + this.offset.click.top, t.top, t.height),
                t = "y" === this.options.axis || this._isOverAxis(this.positionAbs.left + this.offset.click.left, t.left, t.width);
            return !(!e || !t) && (e = this._getDragVerticalDirection(), t = this._getDragHorizontalDirection(), this.floating ? "right" === t || "down" === e ? 2 : 1 : e && ("down" === e ? 2 : 1))
        },
        _intersectsWithSides: function (t) {
            var e = this._isOverAxis(this.positionAbs.top + this.offset.click.top, t.top + t.height / 2, t.height),
                i = this._isOverAxis(this.positionAbs.left + this.offset.click.left, t.left + t.width / 2, t.width),
                s = this._getDragVerticalDirection(), t = this._getDragHorizontalDirection();
            return this.floating && t ? "right" === t && i || "left" === t && !i : s && ("down" === s && e || "up" === s && !e)
        },
        _getDragVerticalDirection: function () {
            var t = this.positionAbs.top - this.lastPositionAbs.top;
            return 0 != t && (0 < t ? "down" : "up")
        },
        _getDragHorizontalDirection: function () {
            var t = this.positionAbs.left - this.lastPositionAbs.left;
            return 0 != t && (0 < t ? "right" : "left")
        },
        refresh: function (t) {
            return this._refreshItems(t), this._setHandleClassName(), this.refreshPositions(), this
        },
        _connectWith: function () {
            var t = this.options;
            return t.connectWith.constructor === String ? [t.connectWith] : t.connectWith
        },
        _getItemsAsjQuery: function (t) {
            var e, i, s, n, o = [], r = [], h = this._connectWith();
            if (h && t) for (e = h.length - 1; 0 <= e; e--) for (i = (s = b(h[e], this.document[0])).length - 1; 0 <= i; i--) (n = b.data(s[i], this.widgetFullName)) && n !== this && !n.options.disabled && r.push([b.isFunction(n.options.items) ? n.options.items.call(n.element) : b(n.options.items, n.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), n]);

            function a() {
                o.push(this)
            }

            for (r.push([b.isFunction(this.options.items) ? this.options.items.call(this.element, null, {
                options: this.options,
                item: this.currentItem
            }) : b(this.options.items, this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), this]), e = r.length - 1; 0 <= e; e--) r[e][0].each(a);
            return b(o)
        },
        _removeCurrentsFromItems: function () {
            var i = this.currentItem.find(":data(" + this.widgetName + "-item)");
            this.items = b.grep(this.items, function (t) {
                for (var e = 0; e < i.length; e++) if (i[e] === t.item[0]) return !1;
                return !0
            })
        },
        _refreshItems: function (t) {
            this.items = [], this.containers = [this];
            var e, i, s, n, o, r, h, a, l = this.items,
                c = [[b.isFunction(this.options.items) ? this.options.items.call(this.element[0], t, {item: this.currentItem}) : b(this.options.items, this.element), this]],
                p = this._connectWith();
            if (p && this.ready) for (e = p.length - 1; 0 <= e; e--) for (i = (s = b(p[e], this.document[0])).length - 1; 0 <= i; i--) (n = b.data(s[i], this.widgetFullName)) && n !== this && !n.options.disabled && (c.push([b.isFunction(n.options.items) ? n.options.items.call(n.element[0], t, {item: this.currentItem}) : b(n.options.items, n.element), n]), this.containers.push(n));
            for (e = c.length - 1; 0 <= e; e--) for (o = c[e][1], i = 0, a = (r = c[e][0]).length; i < a; i++) (h = b(r[i])).data(this.widgetName + "-item", o), l.push({
                item: h,
                instance: o,
                width: 0,
                height: 0,
                left: 0,
                top: 0
            })
        },
        refreshPositions: function (t) {
            var e, i, s, n;
            for (this.floating = !!this.items.length && ("x" === this.options.axis || this._isFloating(this.items[0].item)), this.offsetParent && this.helper && (this.offset.parent = this._getParentOffset()), e = this.items.length - 1; 0 <= e; e--) (i = this.items[e]).instance !== this.currentContainer && this.currentContainer && i.item[0] !== this.currentItem[0] || (s = this.options.toleranceElement ? b(this.options.toleranceElement, i.item) : i.item, t || (i.width = s.outerWidth(), i.height = s.outerHeight()), n = s.offset(), i.left = n.left, i.top = n.top);
            if (this.options.custom && this.options.custom.refreshContainers) this.options.custom.refreshContainers.call(this); else for (e = this.containers.length - 1; 0 <= e; e--) n = this.containers[e].element.offset(), this.containers[e].containerCache.left = n.left, this.containers[e].containerCache.top = n.top, this.containers[e].containerCache.width = this.containers[e].element.outerWidth(), this.containers[e].containerCache.height = this.containers[e].element.outerHeight();
            return this
        },
        _createPlaceholder: function (i) {
            var s, n = (i = i || this).options;
            n.placeholder && n.placeholder.constructor !== String || (s = n.placeholder, n.placeholder = {
                element: function () {
                    var t = i.currentItem[0].nodeName.toLowerCase(), e = b("<" + t + ">", i.document[0]);
                    return i._addClass(e, "ui-sortable-placeholder", s || i.currentItem[0].className)._removeClass(e, "ui-sortable-helper"), "tbody" === t ? i._createTrPlaceholder(i.currentItem.find("tr").eq(0), b("<tr>", i.document[0]).appendTo(e)) : "tr" === t ? i._createTrPlaceholder(i.currentItem, e) : "img" === t && e.attr("src", i.currentItem.attr("src")), s || e.css("visibility", "hidden"), e
                }, update: function (t, e) {
                    s && !n.forcePlaceholderSize || (e.height() || e.height(i.currentItem.innerHeight() - parseInt(i.currentItem.css("paddingTop") || 0, 10) - parseInt(i.currentItem.css("paddingBottom") || 0, 10)), e.width() || e.width(i.currentItem.innerWidth() - parseInt(i.currentItem.css("paddingLeft") || 0, 10) - parseInt(i.currentItem.css("paddingRight") || 0, 10)))
                }
            }), i.placeholder = b(n.placeholder.element.call(i.element, i.currentItem)), i.currentItem.after(i.placeholder), n.placeholder.update(i, i.placeholder)
        },
        _createTrPlaceholder: function (t, e) {
            var i = this;
            t.children().each(function () {
                b("<td>&#160;</td>", i.document[0]).attr("colspan", b(this).attr("colspan") || 1).appendTo(e)
            })
        },
        _contactContainers: function (t) {
            for (var e, i, s, n, o, r, h, a, l, c = null, p = null, u = this.containers.length - 1; 0 <= u; u--) b.contains(this.currentItem[0], this.containers[u].element[0]) || (this._intersectsWith(this.containers[u].containerCache) ? c && b.contains(this.containers[u].element[0], c.element[0]) || (c = this.containers[u], p = u) : this.containers[u].containerCache.over && (this.containers[u]._trigger("out", t, this._uiHash(this)), this.containers[u].containerCache.over = 0));
            if (c) if (1 === this.containers.length) this.containers[p].containerCache.over || (this.containers[p]._trigger("over", t, this._uiHash(this)), this.containers[p].containerCache.over = 1); else {
                for (i = 1e4, s = null, n = (a = c.floating || this._isFloating(this.currentItem)) ? "left" : "top", o = a ? "width" : "height", l = a ? "pageX" : "pageY", e = this.items.length - 1; 0 <= e; e--) b.contains(this.containers[p].element[0], this.items[e].item[0]) && this.items[e].item[0] !== this.currentItem[0] && (r = this.items[e].item.offset()[n], h = !1, t[l] - r > this.items[e][o] / 2 && (h = !0), Math.abs(t[l] - r) < i && (i = Math.abs(t[l] - r), s = this.items[e], this.direction = h ? "up" : "down"));
                (s || this.options.dropOnEmpty) && (this.currentContainer !== this.containers[p] ? (s ? this._rearrange(t, s, null, !0) : this._rearrange(t, null, this.containers[p].element, !0), this._trigger("change", t, this._uiHash()), this.containers[p]._trigger("change", t, this._uiHash(this)), this.currentContainer = this.containers[p], this.options.placeholder.update(this.currentContainer, this.placeholder), this.containers[p]._trigger("over", t, this._uiHash(this)), this.containers[p].containerCache.over = 1) : this.currentContainer.containerCache.over || (this.containers[p]._trigger("over", t, this._uiHash()), this.currentContainer.containerCache.over = 1))
            }
        },
        _createHelper: function (t) {
            var e = this.options,
                t = b.isFunction(e.helper) ? b(e.helper.apply(this.element[0], [t, this.currentItem])) : "clone" === e.helper ? this.currentItem.clone() : this.currentItem;
            return t.parents("body").length || b("parent" !== e.appendTo ? e.appendTo : this.currentItem[0].parentNode)[0].appendChild(t[0]), t[0] === this.currentItem[0] && (this._storedCSS = {
                width: this.currentItem[0].style.width,
                height: this.currentItem[0].style.height,
                position: this.currentItem.css("position"),
                top: this.currentItem.css("top"),
                left: this.currentItem.css("left")
            }), t[0].style.width && !e.forceHelperSize || t.width(this.currentItem.width()), t[0].style.height && !e.forceHelperSize || t.height(this.currentItem.height()), t
        },
        _adjustOffsetFromHelper: function (t) {
            "string" == typeof t && (t = t.split(" ")), b.isArray(t) && (t = {
                left: +t[0],
                top: +t[1] || 0
            }), "left" in t && (this.offset.click.left = t.left + this.margins.left), "right" in t && (this.offset.click.left = this.helperProportions.width - t.right + this.margins.left), "top" in t && (this.offset.click.top = t.top + this.margins.top), "bottom" in t && (this.offset.click.top = this.helperProportions.height - t.bottom + this.margins.top)
        },
        _getParentOffset: function () {
            this.offsetParent = this.helper.offsetParent();
            var t = this.offsetParent.offset();
            return "absolute" === this.cssPosition && this.scrollParent[0] !== this.document[0] && b.contains(this.scrollParent[0], this.offsetParent[0]) && (t.left += this.scrollParent.scrollLeft(), t.top += this.scrollParent.scrollTop()), (this.offsetParent[0] === this.document[0].body || this.offsetParent[0].tagName && "html" === this.offsetParent[0].tagName.toLowerCase() && b.ui.ie) && (t = {
                top: 0,
                left: 0
            }), {
                top: t.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
                left: t.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
            }
        },
        _getRelativeOffset: function () {
            if ("relative" !== this.cssPosition) return {top: 0, left: 0};
            var t = this.currentItem.position();
            return {
                top: t.top - (parseInt(this.helper.css("top"), 10) || 0) + this.scrollParent.scrollTop(),
                left: t.left - (parseInt(this.helper.css("left"), 10) || 0) + this.scrollParent.scrollLeft()
            }
        },
        _cacheMargins: function () {
            this.margins = {
                left: parseInt(this.currentItem.css("marginLeft"), 10) || 0,
                top: parseInt(this.currentItem.css("marginTop"), 10) || 0
            }
        },
        _cacheHelperProportions: function () {
            this.helperProportions = {width: this.helper.outerWidth(), height: this.helper.outerHeight()}
        },
        _setContainment: function () {
            var t, e, i = this.options;
            "parent" === i.containment && (i.containment = this.helper[0].parentNode), "document" !== i.containment && "window" !== i.containment || (this.containment = [0 - this.offset.relative.left - this.offset.parent.left, 0 - this.offset.relative.top - this.offset.parent.top, "document" === i.containment ? this.document.width() : this.window.width() - this.helperProportions.width - this.margins.left, ("document" === i.containment ? this.document.height() || document.body.parentNode.scrollHeight : this.window.height() || this.document[0].body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top]), /^(document|window|parent)$/.test(i.containment) || (t = b(i.containment)[0], e = b(i.containment).offset(), i = "hidden" !== b(t).css("overflow"), this.containment = [e.left + (parseInt(b(t).css("borderLeftWidth"), 10) || 0) + (parseInt(b(t).css("paddingLeft"), 10) || 0) - this.margins.left, e.top + (parseInt(b(t).css("borderTopWidth"), 10) || 0) + (parseInt(b(t).css("paddingTop"), 10) || 0) - this.margins.top, e.left + (i ? Math.max(t.scrollWidth, t.offsetWidth) : t.offsetWidth) - (parseInt(b(t).css("borderLeftWidth"), 10) || 0) - (parseInt(b(t).css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left, e.top + (i ? Math.max(t.scrollHeight, t.offsetHeight) : t.offsetHeight) - (parseInt(b(t).css("borderTopWidth"), 10) || 0) - (parseInt(b(t).css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top])
        },
        _convertPositionTo: function (t, e) {
            e = e || this.position;
            var i = "absolute" === t ? 1 : -1,
                s = "absolute" !== this.cssPosition || this.scrollParent[0] !== this.document[0] && b.contains(this.scrollParent[0], this.offsetParent[0]) ? this.scrollParent : this.offsetParent,
                t = /(html|body)/i.test(s[0].tagName);
            return {
                top: e.top + this.offset.relative.top * i + this.offset.parent.top * i - ("fixed" === this.cssPosition ? -this.scrollParent.scrollTop() : t ? 0 : s.scrollTop()) * i,
                left: e.left + this.offset.relative.left * i + this.offset.parent.left * i - ("fixed" === this.cssPosition ? -this.scrollParent.scrollLeft() : t ? 0 : s.scrollLeft()) * i
            }
        },
        _generatePosition: function (t) {
            var e = this.options, i = t.pageX, s = t.pageY,
                n = "absolute" !== this.cssPosition || this.scrollParent[0] !== this.document[0] && b.contains(this.scrollParent[0], this.offsetParent[0]) ? this.scrollParent : this.offsetParent,
                o = /(html|body)/i.test(n[0].tagName);
            return "relative" !== this.cssPosition || this.scrollParent[0] !== this.document[0] && this.scrollParent[0] !== this.offsetParent[0] || (this.offset.relative = this._getRelativeOffset()), this.originalPosition && (this.containment && (t.pageX - this.offset.click.left < this.containment[0] && (i = this.containment[0] + this.offset.click.left), t.pageY - this.offset.click.top < this.containment[1] && (s = this.containment[1] + this.offset.click.top), t.pageX - this.offset.click.left > this.containment[2] && (i = this.containment[2] + this.offset.click.left), t.pageY - this.offset.click.top > this.containment[3] && (s = this.containment[3] + this.offset.click.top)), e.grid && (t = this.originalPageY + Math.round((s - this.originalPageY) / e.grid[1]) * e.grid[1], s = !this.containment || t - this.offset.click.top >= this.containment[1] && t - this.offset.click.top <= this.containment[3] ? t : t - this.offset.click.top >= this.containment[1] ? t - e.grid[1] : t + e.grid[1], t = this.originalPageX + Math.round((i - this.originalPageX) / e.grid[0]) * e.grid[0], i = !this.containment || t - this.offset.click.left >= this.containment[0] && t - this.offset.click.left <= this.containment[2] ? t : t - this.offset.click.left >= this.containment[0] ? t - e.grid[0] : t + e.grid[0])), {
                top: s - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + ("fixed" === this.cssPosition ? -this.scrollParent.scrollTop() : o ? 0 : n.scrollTop()),
                left: i - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + ("fixed" === this.cssPosition ? -this.scrollParent.scrollLeft() : o ? 0 : n.scrollLeft())
            }
        },
        _rearrange: function (t, e, i, s) {
            i ? i[0].appendChild(this.placeholder[0]) : e.item[0].parentNode.insertBefore(this.placeholder[0], "down" === this.direction ? e.item[0] : e.item[0].nextSibling), this.counter = this.counter ? ++this.counter : 1;
            var n = this.counter;
            this._delay(function () {
                n === this.counter && this.refreshPositions(!s)
            })
        },
        _clear: function (t, e) {
            this.reverting = !1;
            var i, s = [];
            if (!this._noFinalSort && this.currentItem.parent().length && this.placeholder.before(this.currentItem), this._noFinalSort = null, this.helper[0] === this.currentItem[0]) {
                for (i in this._storedCSS) "auto" !== this._storedCSS[i] && "static" !== this._storedCSS[i] || (this._storedCSS[i] = "");
                this.currentItem.css(this._storedCSS), this._removeClass(this.currentItem, "ui-sortable-helper")
            } else this.currentItem.show();

            function n(e, i, s) {
                return function (t) {
                    s._trigger(e, t, i._uiHash(i))
                }
            }

            for (this.fromOutside && !e && s.push(function (t) {
                this._trigger("receive", t, this._uiHash(this.fromOutside))
            }), !this.fromOutside && this.domPosition.prev === this.currentItem.prev().not(".ui-sortable-helper")[0] && this.domPosition.parent === this.currentItem.parent()[0] || e || s.push(function (t) {
                this._trigger("update", t, this._uiHash())
            }), this !== this.currentContainer && (e || (s.push(function (t) {
                this._trigger("remove", t, this._uiHash())
            }), s.push(function (e) {
                return function (t) {
                    e._trigger("receive", t, this._uiHash(this))
                }
            }.call(this, this.currentContainer)), s.push(function (e) {
                return function (t) {
                    e._trigger("update", t, this._uiHash(this))
                }
            }.call(this, this.currentContainer)))), i = this.containers.length - 1; 0 <= i; i--) e || s.push(n("deactivate", this, this.containers[i])), this.containers[i].containerCache.over && (s.push(n("out", this, this.containers[i])), this.containers[i].containerCache.over = 0);
            if (this.storedCursor && (this.document.find("body").css("cursor", this.storedCursor), this.storedStylesheet.remove()), this._storedOpacity && this.helper.css("opacity", this._storedOpacity), this._storedZIndex && this.helper.css("zIndex", "auto" === this._storedZIndex ? "" : this._storedZIndex), this.dragging = !1, e || this._trigger("beforeStop", t, this._uiHash()), this.placeholder[0].parentNode.removeChild(this.placeholder[0]), this.cancelHelperRemoval || (this.helper[0] !== this.currentItem[0] && this.helper.remove(), this.helper = null), !e) {
                for (i = 0; i < s.length; i++) s[i].call(this, t);
                this._trigger("stop", t, this._uiHash())
            }
            return this.fromOutside = !1, !this.cancelHelperRemoval
        },
        _trigger: function () {
            !1 === b.Widget.prototype._trigger.apply(this, arguments) && this.cancel()
        },
        _uiHash: function (t) {
            var e = t || this;
            return {
                helper: e.helper,
                placeholder: e.placeholder || b([]),
                position: e.position,
                originalPosition: e.originalPosition,
                offset: e.positionAbs,
                item: e.currentItem,
                sender: t ? t.element : null
            }
        }
    }), b.widget("ui.slider", b.ui.mouse, {
        version: "1.12.1",
        widgetEventPrefix: "slide",
        options: {
            animate: !1,
            classes: {
                "ui-slider": "ui-corner-all",
                "ui-slider-handle": "ui-corner-all",
                "ui-slider-range": "ui-corner-all ui-widget-header"
            },
            distance: 0,
            max: 100,
            min: 0,
            orientation: "horizontal",
            range: !1,
            step: 1,
            value: 0,
            values: null,
            change: null,
            slide: null,
            start: null,
            stop: null
        },
        numPages: 5,
        _create: function () {
            this._keySliding = !1, this._mouseSliding = !1, this._animateOff = !0, this._handleIndex = null, this._detectOrientation(), this._mouseInit(), this._calculateNewMax(), this._addClass("ui-slider ui-slider-" + this.orientation, "ui-widget ui-widget-content"), this._refresh(), this._animateOff = !1
        },
        _refresh: function () {
            this._createRange(), this._createHandles(), this._setupEvents(), this._refreshValue()
        },
        _createHandles: function () {
            var t, e = this.options, i = this.element.find(".ui-slider-handle"), s = [],
                n = e.values && e.values.length || 1;
            for (i.length > n && (i.slice(n).remove(), i = i.slice(0, n)), t = i.length; t < n; t++) s.push("<span tabindex='0'></span>");
            this.handles = i.add(b(s.join("")).appendTo(this.element)), this._addClass(this.handles, "ui-slider-handle", "ui-state-default"), this.handle = this.handles.eq(0), this.handles.each(function (t) {
                b(this).data("ui-slider-handle-index", t).attr("tabIndex", 0)
            })
        },
        _createRange: function () {
            var t = this.options;
            t.range ? (!0 === t.range && (t.values ? t.values.length && 2 !== t.values.length ? t.values = [t.values[0], t.values[0]] : b.isArray(t.values) && (t.values = t.values.slice(0)) : t.values = [this._valueMin(), this._valueMin()]), this.range && this.range.length ? (this._removeClass(this.range, "ui-slider-range-min ui-slider-range-max"), this.range.css({
                left: "",
                bottom: ""
            })) : (this.range = b("<div>").appendTo(this.element), this._addClass(this.range, "ui-slider-range")), "min" !== t.range && "max" !== t.range || this._addClass(this.range, "ui-slider-range-" + t.range)) : (this.range && this.range.remove(), this.range = null)
        },
        _setupEvents: function () {
            this._off(this.handles), this._on(this.handles, this._handleEvents), this._hoverable(this.handles), this._focusable(this.handles)
        },
        _destroy: function () {
            this.handles.remove(), this.range && this.range.remove(), this._mouseDestroy()
        },
        _mouseCapture: function (t) {
            var i, s, n, o, e, r, h = this, a = this.options;
            return !a.disabled && (this.elementSize = {
                width: this.element.outerWidth(),
                height: this.element.outerHeight()
            }, this.elementOffset = this.element.offset(), r = {
                x: t.pageX,
                y: t.pageY
            }, i = this._normValueFromMouse(r), s = this._valueMax() - this._valueMin() + 1, this.handles.each(function (t) {
                var e = Math.abs(i - h.values(t));
                (e < s || s === e && (t === h._lastChangedValue || h.values(t) === a.min)) && (s = e, n = b(this), o = t)
            }), !1 !== this._start(t, o) && (this._mouseSliding = !0, this._handleIndex = o, this._addClass(n, null, "ui-state-active"), n.trigger("focus"), e = n.offset(), r = !b(t.target).parents().addBack().is(".ui-slider-handle"), this._clickOffset = r ? {
                left: 0,
                top: 0
            } : {
                left: t.pageX - e.left - n.width() / 2,
                top: t.pageY - e.top - n.height() / 2 - (parseInt(n.css("borderTopWidth"), 10) || 0) - (parseInt(n.css("borderBottomWidth"), 10) || 0) + (parseInt(n.css("marginTop"), 10) || 0)
            }, this.handles.hasClass("ui-state-hover") || this._slide(t, o, i), this._animateOff = !0))
        },
        _mouseStart: function () {
            return !0
        },
        _mouseDrag: function (t) {
            var e = {x: t.pageX, y: t.pageY}, e = this._normValueFromMouse(e);
            return this._slide(t, this._handleIndex, e), !1
        },
        _mouseStop: function (t) {
            return this._removeClass(this.handles, null, "ui-state-active"), this._mouseSliding = !1, this._stop(t, this._handleIndex), this._change(t, this._handleIndex), this._handleIndex = null, this._clickOffset = null, this._animateOff = !1
        },
        _detectOrientation: function () {
            this.orientation = "vertical" === this.options.orientation ? "vertical" : "horizontal"
        },
        _normValueFromMouse: function (t) {
            var e,
                t = "horizontal" === this.orientation ? (e = this.elementSize.width, t.x - this.elementOffset.left - (this._clickOffset ? this._clickOffset.left : 0)) : (e = this.elementSize.height, t.y - this.elementOffset.top - (this._clickOffset ? this._clickOffset.top : 0)),
                t = t / e;
            return 1 < t && (t = 1), t < 0 && (t = 0), "vertical" === this.orientation && (t = 1 - t), e = this._valueMax() - this._valueMin(), e = this._valueMin() + t * e, this._trimAlignValue(e)
        },
        _uiHash: function (t, e, i) {
            var s = {handle: this.handles[t], handleIndex: t, value: void 0 !== e ? e : this.value()};
            return this._hasMultipleValues() && (s.value = void 0 !== e ? e : this.values(t), s.values = i || this.values()), s
        },
        _hasMultipleValues: function () {
            return this.options.values && this.options.values.length
        },
        _start: function (t, e) {
            return this._trigger("start", t, this._uiHash(e))
        },
        _slide: function (t, e, i) {
            var s, n = this.value(), o = this.values();
            this._hasMultipleValues() && (s = this.values(e ? 0 : 1), n = this.values(e), 2 === this.options.values.length && !0 === this.options.range && (i = 0 === e ? Math.min(s, i) : Math.max(s, i)), o[e] = i), i !== n && !1 !== this._trigger("slide", t, this._uiHash(e, i, o)) && (this._hasMultipleValues() ? this.values(e, i) : this.value(i))
        },
        _stop: function (t, e) {
            this._trigger("stop", t, this._uiHash(e))
        },
        _change: function (t, e) {
            this._keySliding || this._mouseSliding || (this._lastChangedValue = e, this._trigger("change", t, this._uiHash(e)))
        },
        value: function (t) {
            return arguments.length ? (this.options.value = this._trimAlignValue(t), this._refreshValue(), void this._change(null, 0)) : this._value()
        },
        values: function (t, e) {
            var i, s, n;
            if (1 < arguments.length) return this.options.values[t] = this._trimAlignValue(e), this._refreshValue(), void this._change(null, t);
            if (!arguments.length) return this._values();
            if (!b.isArray(t)) return this._hasMultipleValues() ? this._values(t) : this.value();
            for (i = this.options.values, s = t, n = 0; n < i.length; n += 1) i[n] = this._trimAlignValue(s[n]), this._change(null, n);
            this._refreshValue()
        },
        _setOption: function (t, e) {
            var i, s = 0;
            switch ("range" === t && !0 === this.options.range && ("min" === e ? (this.options.value = this._values(0), this.options.values = null) : "max" === e && (this.options.value = this._values(this.options.values.length - 1), this.options.values = null)), b.isArray(this.options.values) && (s = this.options.values.length), this._super(t, e), t) {
                case"orientation":
                    this._detectOrientation(), this._removeClass("ui-slider-horizontal ui-slider-vertical")._addClass("ui-slider-" + this.orientation), this._refreshValue(), this.options.range && this._refreshRange(e), this.handles.css("horizontal" === e ? "bottom" : "left", "");
                    break;
                case"value":
                    this._animateOff = !0, this._refreshValue(), this._change(null, 0), this._animateOff = !1;
                    break;
                case"values":
                    for (this._animateOff = !0, this._refreshValue(), i = s - 1; 0 <= i; i--) this._change(null, i);
                    this._animateOff = !1;
                    break;
                case"step":
                case"min":
                case"max":
                    this._animateOff = !0, this._calculateNewMax(), this._refreshValue(), this._animateOff = !1;
                    break;
                case"range":
                    this._animateOff = !0, this._refresh(), this._animateOff = !1
            }
        },
        _setOptionDisabled: function (t) {
            this._super(t), this._toggleClass(null, "ui-state-disabled", !!t)
        },
        _value: function () {
            var t = this.options.value;
            return t = this._trimAlignValue(t)
        },
        _values: function (t) {
            var e, i, s;
            if (arguments.length) return e = this.options.values[t], this._trimAlignValue(e);
            if (this._hasMultipleValues()) {
                for (i = this.options.values.slice(), s = 0; s < i.length; s += 1) i[s] = this._trimAlignValue(i[s]);
                return i
            }
            return []
        },
        _trimAlignValue: function (t) {
            if (t <= this._valueMin()) return this._valueMin();
            if (t >= this._valueMax()) return this._valueMax();
            var e = 0 < this.options.step ? this.options.step : 1, i = (t - this._valueMin()) % e, t = t - i;
            return 2 * Math.abs(i) >= e && (t += 0 < i ? e : -e), parseFloat(t.toFixed(5))
        },
        _calculateNewMax: function () {
            var t = this.options.max, e = this._valueMin(), i = this.options.step;
            (t = Math.round((t - e) / i) * i + e) > this.options.max && (t -= i), this.max = parseFloat(t.toFixed(this._precision()))
        },
        _precision: function () {
            var t = this._precisionOf(this.options.step);
            return null !== this.options.min && (t = Math.max(t, this._precisionOf(this.options.min))), t
        },
        _precisionOf: function (t) {
            var e = t.toString(), t = e.indexOf(".");
            return -1 === t ? 0 : e.length - t - 1
        },
        _valueMin: function () {
            return this.options.min
        },
        _valueMax: function () {
            return this.max
        },
        _refreshRange: function (t) {
            "vertical" === t && this.range.css({width: "", left: ""}), "horizontal" === t && this.range.css({
                height: "",
                bottom: ""
            })
        },
        _refreshValue: function () {
            var e, i, t, s, n, o = this.options.range, r = this.options, h = this, a = !this._animateOff && r.animate,
                l = {};
            this._hasMultipleValues() ? this.handles.each(function (t) {
                i = (h.values(t) - h._valueMin()) / (h._valueMax() - h._valueMin()) * 100, l["horizontal" === h.orientation ? "left" : "bottom"] = i + "%", b(this).stop(1, 1)[a ? "animate" : "css"](l, r.animate), !0 === h.options.range && ("horizontal" === h.orientation ? (0 === t && h.range.stop(1, 1)[a ? "animate" : "css"]({left: i + "%"}, r.animate), 1 === t && h.range[a ? "animate" : "css"]({width: i - e + "%"}, {
                    queue: !1,
                    duration: r.animate
                })) : (0 === t && h.range.stop(1, 1)[a ? "animate" : "css"]({bottom: i + "%"}, r.animate), 1 === t && h.range[a ? "animate" : "css"]({height: i - e + "%"}, {
                    queue: !1,
                    duration: r.animate
                }))), e = i
            }) : (t = this.value(), s = this._valueMin(), n = this._valueMax(), i = n !== s ? (t - s) / (n - s) * 100 : 0, l["horizontal" === this.orientation ? "left" : "bottom"] = i + "%", this.handle.stop(1, 1)[a ? "animate" : "css"](l, r.animate), "min" === o && "horizontal" === this.orientation && this.range.stop(1, 1)[a ? "animate" : "css"]({width: i + "%"}, r.animate), "max" === o && "horizontal" === this.orientation && this.range.stop(1, 1)[a ? "animate" : "css"]({width: 100 - i + "%"}, r.animate), "min" === o && "vertical" === this.orientation && this.range.stop(1, 1)[a ? "animate" : "css"]({height: i + "%"}, r.animate), "max" === o && "vertical" === this.orientation && this.range.stop(1, 1)[a ? "animate" : "css"]({height: 100 - i + "%"}, r.animate))
        },
        _handleEvents: {
            keydown: function (t) {
                var e, i, s, n = b(t.target).data("ui-slider-handle-index");
                switch (t.keyCode) {
                    case b.ui.keyCode.HOME:
                    case b.ui.keyCode.END:
                    case b.ui.keyCode.PAGE_UP:
                    case b.ui.keyCode.PAGE_DOWN:
                    case b.ui.keyCode.UP:
                    case b.ui.keyCode.RIGHT:
                    case b.ui.keyCode.DOWN:
                    case b.ui.keyCode.LEFT:
                        if (t.preventDefault(), !this._keySliding && (this._keySliding = !0, this._addClass(b(t.target), null, "ui-state-active"), !1 === this._start(t, n))) return
                }
                switch (s = this.options.step, e = i = this._hasMultipleValues() ? this.values(n) : this.value(), t.keyCode) {
                    case b.ui.keyCode.HOME:
                        i = this._valueMin();
                        break;
                    case b.ui.keyCode.END:
                        i = this._valueMax();
                        break;
                    case b.ui.keyCode.PAGE_UP:
                        i = this._trimAlignValue(e + (this._valueMax() - this._valueMin()) / this.numPages);
                        break;
                    case b.ui.keyCode.PAGE_DOWN:
                        i = this._trimAlignValue(e - (this._valueMax() - this._valueMin()) / this.numPages);
                        break;
                    case b.ui.keyCode.UP:
                    case b.ui.keyCode.RIGHT:
                        if (e === this._valueMax()) return;
                        i = this._trimAlignValue(e + s);
                        break;
                    case b.ui.keyCode.DOWN:
                    case b.ui.keyCode.LEFT:
                        if (e === this._valueMin()) return;
                        i = this._trimAlignValue(e - s)
                }
                this._slide(t, n, i)
            }, keyup: function (t) {
                var e = b(t.target).data("ui-slider-handle-index");
                this._keySliding && (this._keySliding = !1, this._stop(t, e), this._change(t, e), this._removeClass(b(t.target), null, "ui-state-active"))
            }
        }
    })
});
// autocomplete
/**
*  Ajax Autocomplete for jQuery, version 1.2.9
*  (c) Tomas Kirda
*  Ajax Autocomplete for jQuery is freely distributable under the terms of an MIT-style license.
*  For details, see the web site: https://github.com/devbridge/jQuery-Autocomplete
*/
(function(d){"function"===typeof define&&define.amd?define(["jquery"],d):d(jQuery)})(function(d){function g(a,b){var c=function(){},c={autoSelectFirst:!1,appendTo:"body",serviceUrl:null,lookup:null,onSelect:null,width:"auto",minChars:1,maxHeight:300,deferRequestBy:0,params:{},formatResult:g.formatResult,delimiter:null,zIndex:9999,type:"GET",noCache:!1,onSearchStart:c,onSearchComplete:c,onSearchError:c,containerClass:"autocomplete-suggestions",tabDisabled:!1,dataType:"text",currentRequest:null,triggerSelectOnValidInput:!0,
lookupFilter:function(a,b,c){return-1!==a.value.toLowerCase().indexOf(c)},paramName:"query",transformResult:function(a){return"string"===typeof a?d.parseJSON(a):a}};this.element=a;this.el=d(a);this.suggestions=[];this.badQueries=[];this.selectedIndex=-1;this.currentValue=this.element.value;this.intervalId=0;this.cachedResponse={};this.onChange=this.onChangeInterval=null;this.isLocal=!1;this.suggestionsContainer=null;this.options=d.extend({},c,b);this.classes={selected:"autocomplete-selected",suggestion:"autocomplete-suggestion"};
this.hint=null;this.hintValue="";this.selection=null;this.initialize();this.setOptions(b)}var k=function(){return{escapeRegExChars:function(a){return a.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,"\\$&")},createNode:function(a){var b=document.createElement("div");b.className=a;b.style.position="absolute";b.style.display="none";return b}}}();g.utils=k;d.Autocomplete=g;g.formatResult=function(a,b){var c="("+k.escapeRegExChars(b)+")";return a.value.replace(RegExp(c,"gi"),"<strong>$1</strong>")};g.prototype=
{killerFn:null,initialize:function(){var a=this,b="."+a.classes.suggestion,c=a.classes.selected,e=a.options,f;a.element.setAttribute("autocomplete","off");a.killerFn=function(b){0===d(b.target).closest("."+a.options.containerClass).length&&(a.killSuggestions(),a.disableKillerFn())};a.suggestionsContainer=g.utils.createNode(e.containerClass);f=d(a.suggestionsContainer);f.appendTo(e.appendTo);"auto"!==e.width&&f.width(e.width);f.on("mouseover.autocomplete",b,function(){a.activate(d(this).data("index"))});
f.on("mouseout.autocomplete",function(){a.selectedIndex=-1;f.children("."+c).removeClass(c)});f.on("click.autocomplete",b,function(){a.select(d(this).data("index"))});a.fixPosition();a.fixPositionCapture=function(){a.visible&&a.fixPosition()};d(window).on("resize.autocomplete",a.fixPositionCapture);a.el.on("keydown.autocomplete",function(b){a.onKeyPress(b)});a.el.on("keyup.autocomplete",function(b){a.onKeyUp(b)});a.el.on("blur.autocomplete",function(){a.onBlur()});a.el.on("focus.autocomplete",function(){a.onFocus()});
a.el.on("change.autocomplete",function(b){a.onKeyUp(b)})},onFocus:function(){this.fixPosition();if(this.options.minChars<=this.el.val().length)this.onValueChange()},onBlur:function(){this.enableKillerFn()},setOptions:function(a){var b=this.options;d.extend(b,a);if(this.isLocal=d.isArray(b.lookup))b.lookup=this.verifySuggestionsFormat(b.lookup);d(this.suggestionsContainer).css({"max-height":b.maxHeight+"px",width:b.width+"px","z-index":b.zIndex})},clearCache:function(){this.cachedResponse={};this.badQueries=
[]},clear:function(){this.clearCache();this.currentValue="";this.suggestions=[]},disable:function(){this.disabled=!0;this.currentRequest&&this.currentRequest.abort()},enable:function(){this.disabled=!1},fixPosition:function(){var a;"body"===this.options.appendTo&&(a=this.el.offset(),a={top:a.top+this.el.outerHeight()+"px",left:a.left+"px"},"auto"===this.options.width&&(a.width=this.el.outerWidth()-2+"px"),d(this.suggestionsContainer).css(a))},enableKillerFn:function(){d(document).on("click.autocomplete",
this.killerFn)},disableKillerFn:function(){d(document).off("click.autocomplete",this.killerFn)},killSuggestions:function(){var a=this;a.stopKillSuggestions();a.intervalId=window.setInterval(function(){a.hide();a.stopKillSuggestions()},50)},stopKillSuggestions:function(){window.clearInterval(this.intervalId)},isCursorAtEnd:function(){var a=this.el.val().length,b=this.element.selectionStart;return"number"===typeof b?b===a:document.selection?(b=document.selection.createRange(),b.moveStart("character",
-a),a===b.text.length):!0},onKeyPress:function(a){if(!this.disabled&&!this.visible&&40===a.which&&this.currentValue)this.suggest();else if(!this.disabled&&this.visible){switch(a.which){case 27:this.el.val(this.currentValue);this.hide();break;case 39:if(this.hint&&this.options.onHint&&this.isCursorAtEnd()){this.selectHint();break}return;case 9:if(this.hint&&this.options.onHint){this.selectHint();return}case 13:if(-1===this.selectedIndex){this.hide();return}this.select(this.selectedIndex);if(9===a.which&&
!1===this.options.tabDisabled)return;break;case 38:this.moveUp();break;case 40:this.moveDown();break;default:return}a.stopImmediatePropagation();a.preventDefault()}},onKeyUp:function(a){var b=this;if(!b.disabled){switch(a.which){case 38:case 40:return}clearInterval(b.onChangeInterval);if(b.currentValue!==b.el.val())if(b.findBestHint(),0<b.options.deferRequestBy)b.onChangeInterval=setInterval(function(){b.onValueChange()},b.options.deferRequestBy);else b.onValueChange()}},onValueChange:function(){var a=
this.options,b=this.el.val(),c=this.getQuery(b);this.selection&&(this.selection=null,(a.onInvalidateSelection||d.noop).call(this.element));clearInterval(this.onChangeInterval);this.currentValue=b;this.selectedIndex=-1;if(a.triggerSelectOnValidInput&&(b=this.findSuggestionIndex(c),-1!==b)){this.select(b);return}c.length<a.minChars?this.hide():this.getSuggestions(c)},findSuggestionIndex:function(a){var b=-1,c=a.toLowerCase();d.each(this.suggestions,function(a,d){if(d.value.toLowerCase()===c)return b=
a,!1});return b},getQuery:function(a){var b=this.options.delimiter;if(!b)return a;a=a.split(b);return d.trim(a[a.length-1])},getSuggestionsLocal:function(a){var b=this.options,c=a.toLowerCase(),e=b.lookupFilter,f=parseInt(b.lookupLimit,10),b={suggestions:d.grep(b.lookup,function(b){return e(b,a,c)})};f&&b.suggestions.length>f&&(b.suggestions=b.suggestions.slice(0,f));return b},getSuggestions:function(a){var b,c=this,e=c.options,f=e.serviceUrl,l,g;e.params[e.paramName]=a;l=e.ignoreParams?null:e.params;
c.isLocal?b=c.getSuggestionsLocal(a):(d.isFunction(f)&&(f=f.call(c.element,a)),g=f+"?"+d.param(l||{}),b=c.cachedResponse[g]);b&&d.isArray(b.suggestions)?(c.suggestions=b.suggestions,c.suggest()):c.isBadQuery(a)||!1===e.onSearchStart.call(c.element,e.params)||(c.currentRequest&&c.currentRequest.abort(),c.currentRequest=d.ajax({url:f,data:l,type:e.type,dataType:e.dataType}).done(function(b){c.currentRequest=null;c.processResponse(b,a,g);e.onSearchComplete.call(c.element,a)}).fail(function(b,d,f){e.onSearchError.call(c.element,
a,b,d,f)}))},isBadQuery:function(a){for(var b=this.badQueries,c=b.length;c--;)if(0===a.indexOf(b[c]))return!0;return!1},hide:function(){this.visible=!1;this.selectedIndex=-1;d(this.suggestionsContainer).hide();this.signalHint(null)},suggest:function(){if(0===this.suggestions.length)this.hide();else{var a=this.options,b=a.formatResult,c=this.getQuery(this.currentValue),e=this.classes.suggestion,f=this.classes.selected,g=d(this.suggestionsContainer),k=a.beforeRender,m="",h;if(a.triggerSelectOnValidInput&&
(h=this.findSuggestionIndex(c),-1!==h)){this.select(h);return}d.each(this.suggestions,function(a,d){m+='<div class="'+e+'" data-index="'+a+'">'+b(d,c)+"</div>"});"auto"===a.width&&(h=this.el.outerWidth()-2,g.width(0<h?h:300));g.html(m);a.autoSelectFirst&&(this.selectedIndex=0,g.children().first().addClass(f));d.isFunction(k)&&k.call(this.element,g);g.show();this.visible=!0;this.findBestHint()}},findBestHint:function(){var a=this.el.val().toLowerCase(),b=null;a&&(d.each(this.suggestions,function(c,
d){var f=0===d.value.toLowerCase().indexOf(a);f&&(b=d);return!f}),this.signalHint(b))},signalHint:function(a){var b="";a&&(b=this.currentValue+a.value.substr(this.currentValue.length));this.hintValue!==b&&(this.hintValue=b,this.hint=a,(this.options.onHint||d.noop)(b))},verifySuggestionsFormat:function(a){return a.length&&"string"===typeof a[0]?d.map(a,function(a){return{value:a,data:null}}):a},processResponse:function(a,b,c){var d=this.options;a=d.transformResult(a,b);a.suggestions=this.verifySuggestionsFormat(a.suggestions);
d.noCache||(this.cachedResponse[c]=a,0===a.suggestions.length&&this.badQueries.push(c));b===this.getQuery(this.currentValue)&&(this.suggestions=a.suggestions,this.suggest())},activate:function(a){var b=this.classes.selected,c=d(this.suggestionsContainer),e=c.children();c.children("."+b).removeClass(b);this.selectedIndex=a;return-1!==this.selectedIndex&&e.length>this.selectedIndex?(a=e.get(this.selectedIndex),d(a).addClass(b),a):null},selectHint:function(){var a=d.inArray(this.hint,this.suggestions);
this.select(a)},select:function(a){this.hide();this.onSelect(a)},moveUp:function(){-1!==this.selectedIndex&&(0===this.selectedIndex?(d(this.suggestionsContainer).children().first().removeClass(this.classes.selected),this.selectedIndex=-1,this.el.val(this.currentValue),this.findBestHint()):this.adjustScroll(this.selectedIndex-1))},moveDown:function(){this.selectedIndex!==this.suggestions.length-1&&this.adjustScroll(this.selectedIndex+1)},adjustScroll:function(a){var b=this.activate(a),c,e;b&&(b=b.offsetTop,
c=d(this.suggestionsContainer).scrollTop(),e=c+this.options.maxHeight-25,b<c?d(this.suggestionsContainer).scrollTop(b):b>e&&d(this.suggestionsContainer).scrollTop(b-this.options.maxHeight+25),this.el.val(this.getValue(this.suggestions[a].value)),this.signalHint(null))},onSelect:function(a){var b=this.options.onSelect;a=this.suggestions[a];this.currentValue=this.getValue(a.value);this.el.val(this.currentValue);this.signalHint(null);this.suggestions=[];this.selection=a;d.isFunction(b)&&b.call(this.element,
a)},getValue:function(a){var b=this.options.delimiter,c;if(!b)return a;c=this.currentValue;b=c.split(b);return 1===b.length?a:c.substr(0,c.length-b[b.length-1].length)+a},dispose:function(){this.el.off(".autocomplete").removeData("autocomplete");this.disableKillerFn();d(window).off("resize.autocomplete",this.fixPositionCapture);d(this.suggestionsContainer).remove()}};d.fn.autocomplete=function(a,b){return 0===arguments.length?this.first().data("autocomplete"):this.each(function(){var c=d(this),e=
c.data("autocomplete");if("string"===typeof a){if(e&&"function"===typeof e[a])e[a](b)}else e&&e.dispose&&e.dispose(),e=new g(this,a),c.data("autocomplete",e)})}});
