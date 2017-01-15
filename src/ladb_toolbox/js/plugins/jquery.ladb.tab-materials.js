+function ($) {
    'use strict';

    // CONSTANTS
    // ======================

    // Options keys

    var SETTING_KEY_OPTION_PREFIX = 'materials_option_';
    var SETTING_KEY_OPTION_PREFIX_TYPE = SETTING_KEY_OPTION_PREFIX + 'type_';

    var SETTING_KEY_OPTION_SUFFIX_LENGTH_INCREASE = '_length_increase';
    var SETTING_KEY_OPTION_SUFFIX_WIDTH_INCREASE = '_width_increase';
    var SETTING_KEY_OPTION_SUFFIX_THICKNESS_INCREASE = '_thickness_increase';
    var SETTING_KEY_OPTION_SUFFIX_STD_THICKNESSES = '_std_thicknesses';

    // Select picker options

    var SELECT_PICKER_OPTIONS = {
        size: 10,
        iconBase: 'ladb-toolbox-icon',
        tickIcon: 'ladb-toolbox-icon-tick',
        showTick: true
    };

    // CLASS DEFINITION
    // ======================

    var LadbTabMaterials = function (element, options, toolbox) {
        this.options = options;
        this.$element = $(element);
        this.toolbox = toolbox;

        this.materials = [];
        this.editedMaterial = null;

        this.$fileTabs = $('.ladb-file-tabs', this.$element);
        this.$btnList = $('#ladb_btn_list', this.$element);

        this.$page = $('.ladb-page', this.$element);

        this.$modalEditPart = $('#materials_modal', this.$element);
        this.$inputName = $('#ladb_materials_input_name', this.$modalEditPart);
        this.$selectType = $('#ladb_materials_input_type', this.$modalEditPart);
        this.$inputLengthIncrease = $('#ladb_materials_input_length_increase', this.$modalEditPart);
        this.$inputWidthIncrease = $('#ladb_materials_input_width_increase', this.$modalEditPart);
        this.$inputThicknessIncrease = $('#ladb_materials_input_thickness_increase', this.$modalEditPart);
        this.$inputStdThicknesses = $('#ladb_materials_input_std_thicknesses', this.$modalEditPart);
        this.$btnMaterialUpdate = $('#ladb_materials_update', this.$modalEditPart);
    };

    LadbTabMaterials.DEFAULTS = {};

    // List /////

    LadbTabMaterials.prototype.loadList = function () {
        var that = this;

        this.materials = [];
        this.$page.empty();
        this.$btnList.prop('disabled', true);

        rubyCallCommand('materials_list', null, function(data) {

            var errors = data.errors;
            var warnings = data.warnings;
            var filename = data.filename;
            var materials = data.materials;

            // Keep useful data
            that.materials = materials;

            // Update filename
            that.$fileTabs.empty();
            that.$fileTabs.append(Twig.twig({ ref: "tabs/materials/_file-tab.twig" }).render({
                filename: filename
            }));

            // Update page
            that.$page.empty();
            that.$page.append(Twig.twig({ ref: "tabs/materials/_list.twig" }).render({
                errors: errors,
                warnings: warnings,
                materials: materials
            }));

            // Setup tooltips
            that.toolbox.setupTooltips();

            // Bind rows
            $('.ladb-material-box', that.$page).each(function(index) {
                var $box = $(this);
                var materialId = $box.data('material-id');
                $box.on('click', function() {
                    that.editMaterial(materialId);
                });
            });

            // Restore button state
            that.$btnList.prop('disabled', false);

        });

    };

    // Material /////

    LadbTabMaterials.prototype.findMaterialById = function (id) {
        var material;
        for (var i = 0; i < this.materials.length; i++) {
            material = this.materials[i];
            if (material.id == id) {
                return material;
            }
        }
        return null;
    };

    LadbTabMaterials.prototype.editMaterial = function (id) {
        var that = this;

        var material = this.findMaterialById(id);
        if (material) {

            // Keep the edited material
            this.editedMaterial = material;

            // Render modal
            this.$element.append(Twig.twig({ref: "tabs/materials/_modal-material.twig"}).render({
                material: material
            }));

            // Fetch UI elements
            var $modalEditMaterial = $('#ladb_materials_modal_material', this.$element);
            var $inputName = $('#ladb_materials_input_name', $modalEditMaterial);
            var $selectType = $('#ladb_materials_input_type', $modalEditMaterial);
            var $inputLengthIncrease = $('#ladb_materials_input_length_increase', $modalEditMaterial);
            var $inputWidthIncrease = $('#ladb_materials_input_width_increase', $modalEditMaterial);
            var $inputThicknessIncrease = $('#ladb_materials_input_thickness_increase', $modalEditMaterial);
            var $inputStdThicknesses = $('#ladb_materials_input_std_thicknesses', $modalEditMaterial);
            var $btnMaterialUpdate = $('#ladb_materials_update', $modalEditMaterial);

            // Bind modal
            $modalEditMaterial.on('hidden.bs.modal', function () {
                $(this)
                    .data('bs.modal', null)
                    .remove();
            });

            // Bind select
            $selectType.on('change', function () {
                var type = parseInt($(this).val());

                switch (type) {
                    case 0:   // TYPE_UNKNOW
                        $inputLengthIncrease.closest('section').hide();
                        break;
                    case 1:   // TYPE_SOLID_WOOD
                        $inputLengthIncrease.closest('section').show();
                        $inputLengthIncrease.closest('.form-group').show();
                        $inputWidthIncrease.closest('.form-group').show();
                        $inputThicknessIncrease.closest('.form-group').show();
                        $inputStdThicknesses.closest('.form-group').show();
                        break;
                    case 2:   // TYPE_SHEET_GOOD
                        $inputLengthIncrease.closest('section').show();
                        $inputLengthIncrease.closest('.form-group').show();
                        $inputWidthIncrease.closest('.form-group').show();
                        $inputThicknessIncrease.closest('.form-group').hide();
                        $inputStdThicknesses.closest('.form-group').show();
                        break;
                }

                var defaultLengthIncrease,
                    defaultWidthIncrease,
                    defaultThicknessIncrease,
                    defaultStdThicknesses;
                switch (type) {
                    case 0:   // TYPE_UNKNOW
                        defaultLengthIncrease = '0';
                        defaultWidthIncrease = '0';
                        defaultThicknessIncrease = '0';
                        defaultStdThicknesses = '';
                        break;
                    case 1:   // TYPE_SOLID_WOOD
                        defaultLengthIncrease = '50mm';
                        defaultWidthIncrease = '5mm';
                        defaultThicknessIncrease = '5mm';
                        defaultStdThicknesses = '18mm;27mm;35mm;45mm;54mm;65mm;80mm;100mm';
                        break;
                    case 2:   // TYPE_SHEET_GOOD
                        defaultLengthIncrease = '10mm';
                        defaultWidthIncrease = '10mm';
                        defaultThicknessIncrease = '0';
                        defaultStdThicknesses = '4mm;8mm;10mm;15mm;18mm;22mm';
                        break;
                }
                $inputLengthIncrease.val(that.toolbox.getSetting(SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_LENGTH_INCREASE, defaultLengthIncrease));
                $inputWidthIncrease.val(that.toolbox.getSetting(SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_WIDTH_INCREASE, defaultWidthIncrease));
                $inputThicknessIncrease.val(that.toolbox.getSetting(SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_THICKNESS_INCREASE, defaultThicknessIncrease));
                $inputStdThicknesses.tokenfield('setTokens', that.toolbox.getSetting(SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_STD_THICKNESSES, defaultStdThicknesses));

            });
            $selectType.selectpicker(SELECT_PICKER_OPTIONS);

            // Init tokenfield
            $inputStdThicknesses.tokenfield({
                delimiter: ';'
            });

            // Bind buttons
            $btnMaterialUpdate.on('click', function () {

                that.editedMaterial.display_name = $inputName.val();
                that.editedMaterial.attributes.type = $selectType.val();
                that.editedMaterial.attributes.length_increase = $inputLengthIncrease.val();
                that.editedMaterial.attributes.width_increase = $inputWidthIncrease.val();
                that.editedMaterial.attributes.thickness_increase = $inputThicknessIncrease.val();
                that.editedMaterial.attributes.std_thicknesses = $inputStdThicknesses.val();

                rubyCallCommand('materials_update', that.editedMaterial, function() {

                    // Update default cut options to last used
                    that.storeDefaultCutOptionsFormSectionByType(that.editedMaterial.attributes.type);

                    // Reset edited material
                    that.editedMaterial = null;

                    // Hide modal
                    $modalEditMaterial.modal('hide');

                    // Refresh the list
                    that.loadList();

                });

            });

            // Show modal
            $modalEditMaterial.modal('show');

        }
    };

    LadbTabMaterials.prototype.storeDefaultCutOptionsFormSectionByType = function (type) {
        this.toolbox.setSettings([
            { key:SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_LENGTH_INCREASE, value:this.$inputLengthIncrease.val() },
            { key:SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_WIDTH_INCREASE, value:this.$inputWidthIncrease.val() },
            { key:SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_THICKNESS_INCREASE, value:this.$inputThicknessIncrease.val() },
            { key:SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_STD_THICKNESSES, value:this.$inputStdThicknesses.val() }
        ]);
    };

    LadbTabMaterials.prototype.bind = function () {
        var that = this;

        // Bind buttons
        this.$btnList.on('click', function () {
            that.loadList();
            this.blur();
        });

    };

    LadbTabMaterials.prototype.init = function () {
        var that = this;

        var settingsKeys = [];
        for (var type = 0; type <= 2; type++) {
            settingsKeys.push(SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_LENGTH_INCREASE);
            settingsKeys.push(SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_WIDTH_INCREASE);
            settingsKeys.push(SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_THICKNESS_INCREASE);
            settingsKeys.push(SETTING_KEY_OPTION_PREFIX_TYPE + type + SETTING_KEY_OPTION_SUFFIX_STD_THICKNESSES);
        }

        this.toolbox.pullSettings(settingsKeys, function() {

            that.bind();

            setTimeout(function() {
                that.loadList();
            }, 500);

        });

    };


    // PLUGIN DEFINITION
    // =======================

    function Plugin(option, params) {
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('ladb.tabMaterials');
            var options = $.extend({}, LadbTabMaterials.DEFAULTS, $this.data(), typeof option == 'object' && option);

            if (!data) {
                if (options.toolbox == undefined) {
                    throw 'toolbox option is mandatory.';
                }
                $this.data('ladb.tabMaterials', (data = new LadbTabMaterials(this, options, options.toolbox)));
            }
            if (typeof option == 'string') {
                data[option](params);
            } else {
                data.init();
            }
        })
    }

    var old = $.fn.ladbTabMaterials;

    $.fn.ladbTabMaterials = Plugin;
    $.fn.ladbTabMaterials.Constructor = LadbTabMaterials;


    // NO CONFLICT
    // =================

    $.fn.ladbTabMaterials.noConflict = function () {
        $.fn.ladbTabMaterials = old;
        return this;
    }

}(jQuery);