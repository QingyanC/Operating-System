@echo off

rem user define varriants, or take default values.
set self_dir=%CD%
set root_dir=/boot/grub2
set pub_module=part_msdos fat search_fs_file loopback
set self_module=
set file_suffix=
set rw_dir=%self_dir%

echo choose folder or iso-image:
echo 1. iso-image
echo 2. folder
set /p type_code=

if %type_code% == 1 (
	set cfg_file=%self_dir%\def-image.cfg
) else ( if %type_code% == 2 (
	set cfg_file=%self_dir%\def-folder.cfg
) else (
	echo wrong code.
	goto EXIT
))

echo choose your platform:
echo 1. i386-pc
echo 2. i386-efi
echo 3. x86_64-efi
set /p pf_code=

if %pf_code% == 1 (
	set platform=i386-pc
	set file_suffix=.tmp
	set out_file_path=%rw_dir%\g2ldr
	set self_module=biosdisk
) else ( if %pf_code% == 2 (
	set platform=i386-efi
	set out_file_path=%rw_dir%\bootx86.efi
) else ( if %pf_code% == 3 (
	set platform=x86_64-efi
	set out_file_path=%rw_dir%\bootx64.efi
) else (
	echo wrong code.
	goto EXIT
)))

echo your platform: %platform%

pushd ..\


%self_dir%\grub-mkimage.exe -d %platform% -c %cfg_file% -p %root_dir% -o %out_file_path%%file_suffix% -O %platform% %pub_module% %self_module%

if %pf_code% == 1 (
	copy /b %platform%\boot.img+%out_file_path%%file_suffix% %out_file_path%
	del %out_file_path%%file_suffix%
)

popd

:EXIT