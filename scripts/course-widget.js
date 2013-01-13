/*global $, jQuery, $find, window, document*/
var courseWidget = (function () {
    $.fn.courseWidget = function () {
        "use strict";
        var 
        onLoad = function (sectionID, onSaveComplete) {
            options.saveComplete = onSaveComplete;
            options.ele = $("#course-widget-container");
            try { $("#course-widget-btn-save").unbind("click"); } catch (err) { }
            if (sectionID) {
                getJSON("/api/rest/v1/sections/" + sectionID + "/studentSectionAssociations/students");
            }
        },
        getJSON = function (endpoint) {
            $.ajax({
                type: "GET",
                dataType: "json",
                cache: false,
                data: { "p": endpoint },
                url: "/proxy.aspx",
                success: onSuccess,
                error: onError
            });
        },
        onSuccess = function (e) {
            var dom = "",
                fullName,
                li = $("#course-widget-li").html(),
                id;
            if (e) {
                dom = "<ol>";
                if (e.length != 0) {
                    $(e).each(function () {
                        id = this.id;
                        fullName = this.name.lastSurname + ", " + this.name.firstName;
                        dom += li.replace("[id]", id).replace("[name]", fullName);
                    });
                }
                else {
                    dom += "<li>No students found.</li>";
                }
                dom += "</ol>";
                dom += "<input id='course-widget-all-students' type=\"checkbox\" /><span>All Students</span>";
                dom += "<input id='course-widget-all-students-parents' type=\"checkbox\" /><span>All Parents Of Selected Students</span>";
                $("#course-widget-body").html(dom);
                options.bindEvents();
                options.ele.show();
                $("#course-widget-container").modal("show");
            }
        },
        onError = function (e, f, g) {
        },
        onSave = function (e) {
            var students = $(".course-student"),
                ids = [],
                checked = false,
                i = 0;
            if (students.length != 0) {
                students.each(function () {
                    checked = $(this).is(":checked");
                    ids[i] = {
                        id: $(this).data("id"),
                        sendToStudent: checked, 
                        sendToParent: $($(this).parent().children()[2]).data("send") 
                    };
                    i++;
                });
            }
            debugger
            if ($.isFunction(options.saveComplete)) {
                options.saveComplete(ids);
            }
            options.ele.hide();
            return false;
        },
        onAllClick = function () {
            $(".course-student").attr("checked", this.checked);
        },
        onAllParentClick = function () {
            $(".course-parent").attr("checked", this.checked);
        },
        onParentClick = function (e) {
            $(e.currentTarget).data("send", this.checked);
        },
        onEventBind = function () {
            $("#course-widget-btn-save").bind("click", options.saveClick);
            $("#course-widget-all-students").bind("click", options.allClick);
            $("#course-widget-all-students-parents").bind("click", options.allParentClick);
            $(".course-parent").bind("click", options.parentClick);
        },
        options = {
            ele: null,
            load: onLoad,
            bindEvents: onEventBind,
            allClick: onAllClick,
            saveClick: onSave,
            allParentClick: onAllParentClick,
            parentClick: onParentClick
        };
        return options;
    };
    return $().courseWidget();
})(jQuery);
 