package dev_toolbox.toolbox_tabs;

import dev_toolbox.sparrow_optimization.SparrowOptimization;
import ZipUtils.ZipProgress;
import openfl.net.FileReference;
import openfl.utils.Assets;
import lime.app.Application;
import flixel.group.FlxSpriteGroup;
import openfl.geom.Rectangle;
import openfl.display.PNGEncoderOptions;
import lime.ui.FileDialogType;
import flixel.addons.transition.FlxTransitionableState;
import dev_toolbox.file_explorer.FileExplorer;
import openfl.display.BitmapData;
import flixel.tweens.FlxTween;
using StringTools;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.ui.*;
import haxe.Json;
import sys.io.File;
import flixel.text.FlxText;
import flixel.FlxSprite;
import sys.FileSystem;
import lime.ui.FileDialog;

class InfoTab extends ToolboxTab {
    public var card:ModCard;
    var mod_name:FlxUIInputText;
    var mod_description:FlxUIInputText;
    var titlebarName:FlxUIInputText;
    var discordRPCField:FlxUIInputText;
    var downloadLinkField:FlxUIInputText;
    var downloadLinkAltField:FlxUIInputText;
    var winButtons:FlxSprite;
    var titlebarIcon:FlxSprite;
    var titleBarText:FlxText;

    public function new(x:Float, y:Float, home:ToolboxHome) {
        super(x, y, "info", home);
        var name = ModSupport.modConfig[ToolboxHome.selectedMod].name;
        if (name == null) name = ToolboxHome.selectedMod;
        var desc = ModSupport.modConfig[ToolboxHome.selectedMod].description;
        if (desc == null) desc = "(No description)";
        var title = ModSupport.modConfig[ToolboxHome.selectedMod].titleBarName;
        if (title == null) title = 'Friday Night Funkin\' ${ToolboxHome.selectedMod}';
        var rpc = ModSupport.modConfig[ToolboxHome.selectedMod].discordRpc;
        if (rpc == null) rpc = "";
        var downloadLink = ModSupport.modConfig[ToolboxHome.selectedMod].downloadLink;
        if (downloadLink == null) downloadLink = "";
        var downloadLinkAlt = ModSupport.modConfig[ToolboxHome.selectedMod].downloadLinkAlt;
        if (downloadLinkAlt == null) downloadLinkAlt = "";
        
        var bg = new FlxSprite(0, 0).makeGraphic(320, Std.int(FlxG.height - y), 0xFF8C8C8C);
        bg.pixels.lock();
        bg.pixels.fillRect(new Rectangle(318, 0, 1, Std.int(FlxG.height - y)), 0xFF4C4C4C);
        bg.pixels.fillRect(new Rectangle(319, 0, 1, Std.int(FlxG.height - y)), 0xFF000000);
        bg.pixels.unlock();

        card = new ModCard(ToolboxHome.selectedMod, ModSupport.modConfig[ToolboxHome.selectedMod]);
        card.screenCenter(Y);
        card.x = 320 + ((FlxG.width - 320) / 2) - (card.width / 2);

        var OHMYFUCKINGGODITSTHELABELARMY:Array<FlxUIText> = [];
        var label = new FlxUIText(10, 10, 300, "Mod name");
        OHMYFUCKINGGODITSTHELABELARMY.push(label);
        mod_name = new FlxUIInputText(10, label.y + label.height, 300, name);

		var label = new FlxUIText(10, mod_name.y + mod_name.height + 10, 300, "Mod description");
        OHMYFUCKINGGODITSTHELABELARMY.push(label);
        mod_description = new FlxUIInputText(10, label.y + label.height, 300, desc.replace("\r", "").replace("\n", "/n"));
        mod_description.lines = -1;
		var label = new FlxUIText(10, mod_description.y + mod_description.height + 10, 300, "Titlebar Name");
        OHMYFUCKINGGODITSTHELABELARMY.push(label);
        titlebarName = new FlxUIInputText(10, label.y + label.height, 300, title);

		var label = new FlxUIText(10, titlebarName.y + titlebarName.height + 10, 300, "Discord RPC Client ID (leave empty for none)");
        OHMYFUCKINGGODITSTHELABELARMY.push(label);
        discordRPCField = new FlxUIInputText(10, label.y + label.height, 300, rpc);
        
		var label = new FlxUIText(10, discordRPCField.y + discordRPCField.height + 10, 300, "Download Link (leave empty for none)");
        OHMYFUCKINGGODITSTHELABELARMY.push(label);
        downloadLinkField = new FlxUIInputText(10, label.y + label.height, 300, downloadLink);
        
		var label = new FlxUIText(10, downloadLinkField.y + downloadLinkField.height + 10, 300, "Alternative Download Link (leave empty for none)");
        OHMYFUCKINGGODITSTHELABELARMY.push(label);
        downloadLinkAltField = new FlxUIInputText(10, label.y + label.height, 300, downloadLinkAlt);

        var modIcon = new FlxUISprite(85, downloadLinkAltField.y + downloadLinkAltField.height + 10)
        .loadGraphic(
            FileSystem.exists('${Paths.modsPath}/${ToolboxHome.selectedMod}/modIcon.png')
            ? BitmapData.fromFile('${Paths.modsPath}/${ToolboxHome.selectedMod}/modIcon.png')
            : Paths.image("modEmptyIcon", "preload")
        );
        modIcon.setGraphicSize(150, 150);
        modIcon.updateHitbox();
        modIcon.scale.set(Math.min(modIcon.scale.x, modIcon.scale.y), Math.min(modIcon.scale.x, modIcon.scale.y));

        var chooseIconButton = new FlxUIButton(85, modIcon.y + 160, "Choose a mod icon", function() {
            CoolUtil.openDialogue(FileDialogType.OPEN, "Select an mod icon.", function(path) {
                modIcon.loadGraphic(BitmapData.fromFile(path));
                modIcon.setGraphicSize(150, 150);
                modIcon.updateHitbox();
                modIcon.scale.set(Math.min(modIcon.scale.x, modIcon.scale.y), Math.min(modIcon.scale.x, modIcon.scale.y));
            });
        });
        chooseIconButton.resize(150, 20);

        function save() {
            var e = ModSupport.modConfig[ToolboxHome.selectedMod];
            e.name = mod_name.text;
            e.description = mod_description.text.replace("/n", "\n");
            e.titleBarName = titlebarName.text;
            var needRefresh = false;

            // by the laws of programming this works
            needRefresh = (e.discordRpc != (e.discordRpc = discordRPCField.text.trim() == "" ? null : discordRPCField.text.trim())) || needRefresh;
            needRefresh = (e.downloadLink != (e.downloadLink = (downloadLinkField.text != null && (downloadLinkField.text = downloadLinkField.text.trim()) != "") ? downloadLinkField.text : null)) || needRefresh;
            needRefresh = (e.downloadLinkAlt != (e.downloadLinkAlt = (downloadLinkAltField.text != null && (downloadLinkAltField.text = downloadLinkAltField.text.trim()) != "") ? downloadLinkAltField.text : null)) || needRefresh;
            
            if (needRefresh) {
                ModSupport.refreshDiscordRpc();
            }
            File.saveBytes('${Paths.modsPath}/${ToolboxHome.selectedMod}/modIcon.png', modIcon.pixels.encode(modIcon.pixels.rect, new PNGEncoderOptions(true)));
            ModSupport.saveModData(ToolboxHome.selectedMod);
            card.updateMod(ToolboxHome.selectedMod);
        };
        
        var saveButton = new FlxUIButton(10, chooseIconButton.y + 30, "Save", save);
        saveButton.resize(145, 20);
        var lockButton = new FlxUIButton(165, chooseIconButton.y + 30, "Save & Lock", function() {
            FlxG.state.openSubState(new ToolboxMessage("== READ BEFORE LOCKING ==", "You are going to lock your mod.\nLocking your mod makes it impossible to be edited using the Toolbox, or any editors. Pressing \"Yes\" will send you in the Main Menu, and you won't be able to edit your mod.\n\nAre you sure you want to continue?\nTip: You can unlock your mod if you locked it by accident by setting \"locked\" to false in config.json", [
                {
                    label: "Yes",
                    onClick: function(m) {
                        ModSupport.modConfig[ToolboxHome.selectedMod].locked = true;
                        save();
                        FlxG.switchState(new MainMenuState());
                    }
                },
                {
                    label: "No",
                    onClick: function(m) {}
                }
            ]));
        });
        lockButton.color = 0xFFFF5D44;
        lockButton.label.color = -1;
        lockButton.resize(145, 20);
        var lockIcon = CoolUtil.createUISprite("lock", lockButton);
        lockIcon.x = lockButton.x + 2;

        var packButton = new FlxUIButton(10, saveButton.y + saveButton.height + 10, "Create a release (.ycemod file)", function() {
            var saveFileDialog = new FileDialogExt();
            saveFileDialog.openSaveDialog(function(path) {
                var e = ZipUtils.createZipFile(path);
                ModSupport.modConfig[ToolboxHome.selectedMod].locked = true;
                ModSupport.saveModData(ToolboxHome.selectedMod);
                var prog = ZipUtils.writeFolderToZipAsync(e, './mods/${ToolboxHome.selectedMod}/', '${ToolboxHome.selectedMod}/');

                FlxG.state.openSubState(new ProgressBarWindow(prog, "Creating release", "Please wait while the mod is being packed.\nThe result .ycemod file will automatically be locked.", function() {
                    e.flush();
                    e.close();
                    ModSupport.modConfig[ToolboxHome.selectedMod].locked = false;
                    ModSupport.saveModData(ToolboxHome.selectedMod);
                    FlxG.state.openSubState(new ToolboxMessage("Success", "A release .ycemod file for your mod has been created.\nThe mod was automatically locked to prevent players from modifying the content.\n\nYou can click \"OK\", or choose \"Open Folder\" to open the .ycemod's folder.", [
                        {
                            label: "Open Folder",
                            onClick: function(v) {
                                CoolUtil.pointFileInFolder(path);
                            }
                        },
                        {
                            label: "OK",
                            onClick: function(v) {}
                        }
                    ]));
                }));
                
            }, 'ycemod', '${ToolboxHome.selectedMod}.ycemod', "Save mod release.");
        });
        packButton.resize(300, 20);
        packButton.color = 0xFF44BB44;
        packButton.label.color = -1;

        var packIcon = CoolUtil.createUISprite("pack", packButton);
        packIcon.x = packButton.x + 2;

        var optimizeSparrowsButton = new FlxUIButton(10, packButton.y + packButton.height + 10, "Optimize Sparrow Atlases (BETA)", function() {
            FlxG.state.openSubState(new ToolboxMessage(
                "Optimize Sparrow Atlases",
                "This option will cycle through all sparrow atlases in your mod, and optimize them by removing the unnecessary white spaces added by Adobe Animate upon generation.\nThis operation will take some time. Are you sure you want to continue?",
                [
                    {
                        label: "Yes",
                        onClick: function(t) {
                            var prog:ZipProgress = SparrowOptimization.optimizeAsync('${Paths.modsPath}/${ToolboxHome.selectedMod}/');
                            FlxG.state.openSubState(new ProgressBarWindow(prog, "Optimizing Sparrow Atlases...", "Please wait while the engine optimizes the sparrow atlases.", function() {
                                FlxG.state.openSubState(ToolboxMessage.showMessage("Success", "All Sparrow Atlases has been optimized."));
                            }));
                        }
                    },
                    {
                        label: "No",
                        onClick: function(t) {

                        }
                    }
                ]));
        });
        optimizeSparrowsButton.resize(300, 20);

        add(bg);

        for (l in OHMYFUCKINGGODITSTHELABELARMY) add(l);
        add(mod_name);
        add(mod_description);
        add(titlebarName);
        add(discordRPCField);
        add(downloadLinkField);
        add(downloadLinkAltField);
        add(modIcon);
        add(chooseIconButton);
        add(saveButton);
        add(lockButton);
        add(lockIcon);
        add(packButton);
        add(packIcon);
        add(optimizeSparrowsButton);
        
        var win10window = new FlxSpriteGroup();

        var windowSprite = new FlxSprite().makeGraphic(Std.int(card.width + 60), Std.int(card.height + 91), 0xFFFFFFFF, true);
        windowSprite.pixels.lock();
        windowSprite.pixels.fillRect(new Rectangle(0, 0, windowSprite.pixels.width, 1), 0xFF888888);
        windowSprite.pixels.fillRect(new Rectangle(0, 0, 1, windowSprite.pixels.height), 0xFF888888);
        windowSprite.pixels.fillRect(new Rectangle(0, windowSprite.pixels.height - 1, windowSprite.pixels.width, 1), 0xFF888888);
        windowSprite.pixels.fillRect(new Rectangle(windowSprite.pixels.width - 1, 0, 1, windowSprite.pixels.height), 0xFF888888);
        windowSprite.pixels.unlock();

        winButtons = new FlxSprite().loadGraphic(Paths.image('ui/win10titlebar', 'shared'));
        winButtons.antialiasing = true;
        winButtons.setPosition(Std.int(windowSprite.x + windowSprite.width - 1 - winButtons.width), 1);

        titlebarIcon = new FlxSprite(9, 7);
        titlebarIcon.antialiasing = true;

        if (Assets.exists(Paths.file('icon.png', 'mods/${ToolboxHome.selectedMod}'))) {
            titlebarIcon.loadGraphic(Paths.file('icon.png', 'mods/${ToolboxHome.selectedMod}'));
        } else {
            titlebarIcon.loadGraphic(Paths.image('ui/icon16', 'shared'));
        }
        titlebarIcon.setGraphicSize(16, 16);
        titlebarIcon.updateHitbox();

        titleBarText = new FlxText(31, 11, winButtons.x - 41, "Test Window");
        titleBarText.setFormat("C:\\Windows\\Fonts\\segoeui.ttf", 13);
        titleBarText.color = 0xFF000000;
        titleBarText.y = Std.int(1 + ((30 - titleBarText.height) / 2));
        
        win10window.add(windowSprite);
        win10window.add(winButtons);
        win10window.add(titlebarIcon);
        win10window.add(titleBarText);
        win10window.screenCenter();
        win10window.x -= win10window.x % 1;
        win10window.y -= win10window.y % 1;
        win10window.x += 150;
        add(win10window);
        add(card);

    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
        titlebarIcon.antialiasing = ((titleBarText.antialiasing = winButtons.antialiasing = (FlxG.width != Application.current.window.width) && (FlxG.height != Application.current.window.height)) && (titlebarIcon.scale.x != 0 || titlebarIcon.scale.y != 0));
        titleBarText.text = titlebarName.text;
        
    }
}