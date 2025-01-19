GRUB_THEMES=ayyildiz-theme/grub\
	dolunay-theme/grub\
	optimum-theme/grub\
	purple-theme/grub\
	runner-theme/grub
DEFAULT_BACKGROUND=desktop-background

PIXMAPS=$(wildcard pixmaps/*.png)
DESKTOPFILES=$(wildcard *.desktop)

.PHONY: all clean install install-local
all: build-grub build-emblems build-logos
clean: clean-grub clean-emblems clean-logos

.PHONY: build-grub clean-grub install-grub
build-grub clean-grub install-grub:
	@target=`echo $@ | sed s/-grub//`; \
	for grub_theme in $(GRUB_THEMES) ; do \
		if [ -f $$grub_theme/Makefile ] ; then \
			$(MAKE) $$target -C $$grub_theme || exit 1; \
		fi \
	done

.PHONY: build-emblems clean-emblems install-emblems
build-emblems clean-emblems install-emblems:
	@target=`echo $@ | sed s/-emblems//`; \
	$(MAKE) $$target -C emblems-pardus || exit 1;

.PHONY: build-logos clean-logos install-logos
build-logos clean-logos install-logos:
	@target=`echo $@ | sed s/-logos//`; \
	$(MAKE) $$target -C pardus-logos || exit 1;


install: install-grub install-emblems install-logos install-local

install-local:
	# debian logo in circle as default user face icon
	install -d $(DESTDIR)/etc/skel
	$(INSTALL_DATA) defaults/common/etc/skel/.face $(DESTDIR)/etc/skel
	cd $(DESTDIR)/etc/skel && ln -s .face .face.icon

	# background files
	mkdir -p $(DESTDIR)/usr/share/images/desktop-base
	cd $(DESTDIR)/usr/share/images/desktop-base && ln -s $(DEFAULT_BACKGROUND) default
	# desktop files
	mkdir -p $(DESTDIR)/usr/share/desktop-base
	$(INSTALL_DATA) $(DESKTOPFILES) $(DESTDIR)/usr/share/desktop-base/
	# pixmaps files
	mkdir -p $(DESTDIR)/usr/share/pixmaps
	$(INSTALL_DATA) $(PIXMAPS) $(DESTDIR)/usr/share/pixmaps/

	# Create a 'debian-theme' symlink in plymouth themes folder, pointing at the
	# plymouth theme for the currently active 'desktop-theme' alternative.
	mkdir -p $(DESTDIR)/usr/share/plymouth/themes
	ln -s ../../desktop-base/active-theme/plymouth $(DESTDIR)/usr/share/plymouth/themes/debian-theme

	# Set Plasma 5 customizations
	install -d $(DESTDIR)/etc/xdg/autostart
	$(INSTALL_DATA) defaults/kde/etc/xdg/kcm-about-distrorc $(DESTDIR)/etc/xdg
	$(INSTALL_DATA) defaults/kde/etc/xdg/kickoffrc $(DESTDIR)/etc/xdg
	$(INSTALL_DATA) $(wildcard defaults/kde/etc/xdg/autostart/*) $(DESTDIR)/etc/xdg/autostart/
	install -d $(DESTDIR)/etc/xdg/plasma-workspace/env
	$(INSTALL_DATA) $(wildcard defaults/kde/etc/xdg/plasma-workspace/env/*) $(DESTDIR)/etc/xdg/plasma-workspace/env/
	install -d $(DESTDIR)/usr/share/desktop-base/kf5-settings
	$(INSTALL_DATA) $(wildcard defaults/kde/kf5-settings/*) $(DESTDIR)/usr/share/desktop-base/kf5-settings/
	install -d $(DESTDIR)/usr/share/plasma/look-and-feel/org.debian.desktop/contents
	$(INSTALL_DATA) defaults/kde/plasma/look-and-feel/org.debian.desktop/metadata.json $(DESTDIR)/usr/share/plasma/look-and-feel/org.debian.desktop
	$(INSTALL_DATA) defaults/kde/plasma/look-and-feel/org.debian.desktop/contents/defaults $(DESTDIR)/usr/share/plasma/look-and-feel/org.debian.desktop/contents
	install -d $(DESTDIR)/usr/share/plasma/look-and-feel/org.debian.desktop/contents/layouts
	$(INSTALL_DATA) $(wildcard defaults/kde/plasma/look-and-feel/org.debian.desktop/contents/layouts/*) $(DESTDIR)/usr/share/plasma/look-and-feel/org.debian.desktop/contents/layouts/
	install -d $(DESTDIR)/usr/share/plasma/look-and-feel/org.debian.desktop/contents/previews
	$(INSTALL_DATA) $(wildcard defaults/kde/plasma/look-and-feel/org.debian.desktop/contents/previews/*) $(DESTDIR)/usr/share/plasma/look-and-feel/org.debian.desktop/contents/previews/

	# Xfce 4.6
	mkdir -p $(DESTDIR)/usr/share/desktop-base/profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml
	$(INSTALL_DATA) $(wildcard profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml/*) $(DESTDIR)/usr/share/desktop-base/profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml

	# GNOME background descriptors
	mkdir -p $(DESTDIR)/usr/share/gnome-background-properties


	# Runner theme (Onyedi's default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/runner
	$(INSTALL_DATA) $(wildcard runner-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/runner
	install -d $(DESTDIR)/usr/share/desktop-base/runner-theme
	cd $(DESTDIR)/usr/share/desktop-base/runner-theme && ln -s /usr/share/plymouth/themes/runner plymouth


	# Purple theme (Ondokuz's default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/purple
	$(INSTALL_DATA) $(wildcard purple-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/purple
	install -d $(DESTDIR)/usr/share/desktop-base/purple-theme
	cd $(DESTDIR)/usr/share/desktop-base/purple-theme && ln -s /usr/share/plymouth/themes/purple plymouth


	# Optimum theme (Ondokuz's secondary)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/optimum
	$(INSTALL_DATA) $(wildcard optimum-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/optimum
	install -d $(DESTDIR)/usr/share/desktop-base/optimum-theme
	cd $(DESTDIR)/usr/share/desktop-base/optimum-theme && ln -s /usr/share/plymouth/themes/optimum plymouth


	# Dolunay theme (Yirmibir's default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/dolunay
	$(INSTALL_DATA) $(wildcard dolunay-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/dolunay
	install -d $(DESTDIR)/usr/share/desktop-base/dolunay-theme
	cd $(DESTDIR)/usr/share/desktop-base/dolunay-theme && ln -s /usr/share/plymouth/themes/dolunay plymouth


	# Ayyildiz theme (Yirmiuc's default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/ayyildiz
	$(INSTALL_DATA) $(wildcard ayyildiz-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/ayyildiz
	install -d $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme
	cd $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme && ln -s /usr/share/plymouth/themes/ayyildiz plymouth

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/wallpaper/contents/images
	$(INSTALL_DATA) ayyildiz-theme/wallpaper/metadata.json $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/wallpaper
	$(INSTALL_DATA) ayyildiz-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/wallpaper
	$(INSTALL_DATA) $(wildcard ayyildiz-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/wallpaper/contents/images/
	$(INSTALL_DATA) ayyildiz-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/pardus-ayyildiz.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/ayyildiz-theme/wallpaper ayyildiz

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/login
	$(INSTALL_DATA) $(wildcard ayyildiz-theme/login/*) $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/login

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/lockscreen/contents/images
	$(INSTALL_DATA) ayyildiz-theme/wallpaper/metadata.json $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/lockscreen
	$(INSTALL_DATA) ayyildiz-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/lockscreen
	$(INSTALL_DATA) $(wildcard ayyildiz-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/ayyildiz-theme/lockscreen/contents/images/

	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/ayyildiz-theme/wallpaper ayyildiz_wallpaper

include Makefile.inc
