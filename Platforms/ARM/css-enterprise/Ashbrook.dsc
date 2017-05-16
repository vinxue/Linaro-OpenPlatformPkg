#
#  Copyright (c) 2013-2014, ARM Limited. All rights reserved.
#
#  This program and the accompanying materials
#  are licensed and made available under the terms and conditions of the BSD License
#  which accompanies this distribution.  The full text of the license may be found at
#  http://opensource.org/licenses/bsd-license.php
#
#  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
#  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
!if $(ASHBROOK_VARIANT) == 2
  PLATFORM_NAME                  = Ashbrook_DevPlatform
  PLATFORM_GUID                  = 947f8411-9b98-4807-9fee-1e1c04af717b
!else
  PLATFORM_NAME                  = Ashbrook_5_DevPlatform
  PLATFORM_GUID                  = a8180daa-fb8b-11e5-ab24-9fc3167c073d
!endif
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/$(PLATFORM_NAME)
  SUPPORTED_ARCHITECTURES        = AARCH64|ARM
  BUILD_TARGETS                  = DEBUG|RELEASE
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = OpenPlatformPkg/Platforms/ARM/css-enterprise/Ashbrook.fdf

# On RTSM, most peripherals are VExpress Motherboard peripherals
!include OpenPlatformPkg/Platforms/ARM/VExpress/ArmVExpress.dsc.inc

[LibraryClasses.common]
  ArmPlatformLib|OpenPlatformPkg/Platforms/ARM/css-enterprise/Library/AshbrookLib/AshbrookLib.inf
  ArmHvcLib|ArmPkg/Library/ArmHvcLib/ArmHvcLib.inf
  # ARM Base Library
  ArmLib|ArmPkg/Library/ArmLib/ArmBaseLib.inf
  ArmMmuLib|ArmPkg/Library/ArmMmuLib/ArmMmuBaseLib.inf
  ArmSmcLib|ArmPkg/Library/ArmSmcLib/ArmSmcLib.inf

  BasePathLib|ShellPkg/Library/UefiShellLib/UefiShellLib.inf

  ArmPlatformSysConfigLib|ArmPlatformPkg/ArmVExpressPkg/Library/ArmVExpressSysConfigLib/ArmVExpressSysConfigLib.inf
  NorFlashPlatformLib|OpenPlatformPkg/Platforms/ARM/css-enterprise/Library/NorFlashAshbrookLib/NorFlashAshbrookLib.inf
  EfiResetSystemLib|ArmPkg/Library/ArmPsciResetSystemLib/ArmPsciResetSystemLib.inf

  TimerLib|ArmPkg/Library/ArmArchTimerLib/ArmArchTimerLib.inf

  # Virtio Support
  VirtioLib|OvmfPkg/Library/VirtioLib/VirtioLib.inf
  VirtioMmioDeviceLib|OvmfPkg/Library/VirtioMmioDeviceLib/VirtioMmioDeviceLib.inf
  FileExplorerLib|MdeModulePkg/Library/FileExplorerLib/FileExplorerLib.inf

[LibraryClasses.common.SEC]
  PrePiLib|EmbeddedPkg/Library/PrePiLib/PrePiLib.inf
  ExtractGuidedSectionLib|EmbeddedPkg/Library/PrePiExtractGuidedSectionLib/PrePiExtractGuidedSectionLib.inf
  LzmaDecompressLib|IntelFrameworkModulePkg/Library/LzmaCustomDecompressLib/LzmaCustomDecompressLib.inf
  MemoryAllocationLib|EmbeddedPkg/Library/PrePiMemoryAllocationLib/PrePiMemoryAllocationLib.inf
  HobLib|EmbeddedPkg/Library/PrePiHobLib/PrePiHobLib.inf
  PrePiHobListPointerLib|ArmPlatformPkg/Library/PrePiHobListPointerLib/PrePiHobListPointerLib.inf
  PerformanceLib|MdeModulePkg/Library/PeiPerformanceLib/PeiPerformanceLib.inf
  PlatformPeiLib|ArmPlatformPkg/PlatformPei/PlatformPeiLib.inf
  MemoryInitPeiLib|ArmPlatformPkg/MemoryInitPei/MemoryInitPeiLib.inf

[BuildOptions]
!ifdef $(ASHBROOK_EMULATOR)
  *_*_*_ARCHCC_FLAGS = -DASHBROOK_EMULATOR=1
  *_*_*_PP_FLAGS     = -DASHBROOK_EMULATOR=1
!endif
  *_*_*_PLATFORM_FLAGS == -I$(WORKSPACE)/ArmPlatformPkg/ArmVExpressPkg/Include -I$(WORKSPACE)/OpenPlatformPkg/Platforms/ARM/css-enterprise/Include

################################################################################
#
# Pcd Section - list of all EDK II PCD Entries defined by this Platform
#
################################################################################

[PcdsFeatureFlag.common]
  gArmPlatformTokenSpaceGuid.PcdSystemMemoryInitializeInSec|TRUE

  ## If TRUE, Graphics Output Protocol will be installed on virtual handle created by ConsplitterDxe.
  #  It could be set FALSE to save size.
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutGopSupport|FALSE

  gEfiMdeModulePkgTokenSpaceGuid.PcdTurnOffUsbLegacySupport|TRUE

  gArmPlatformTokenSpaceGuid.PcdBdsLinuxSupport|FALSE

!ifdef $(ASHBROOK_EMULATOR)
  gAshbrookTokenSpaceGuid.PcdVirtioSupported|FALSE
!endif

[PcdsFixedAtBuild.common]
  gArmPlatformTokenSpaceGuid.PcdFirmwareVendor|"Ashbrook"
  gEmbeddedTokenSpaceGuid.PcdEmbeddedPrompt|"Ashbrook"

  #
  # NV Storage PCDs. Use base of 0x08000000 for NOR0, 0xC0000000 for NOR 1
  #
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageVariableBase|0x0BFC0000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageVariableSize|0x00010000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwWorkingBase|0x0BFD0000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwWorkingSize|0x00010000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwSpareBase|0x0BFE0000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwSpareSize|0x00010000

  # System Memory (1GB - 16MB of Trusted DRAM at the top of the 32bit address space)
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x80000000
  gArmTokenSpaceGuid.PcdSystemMemorySize|0x40000000

  # Ashbrook 12-Cluster profile
!if $(ASHBROOK_VARIANT) == 2
  gArmPlatformTokenSpaceGuid.PcdCoreCount|4
!else
  gArmPlatformTokenSpaceGuid.PcdCoreCount|2
!endif
  gArmPlatformTokenSpaceGuid.PcdClusterCount|12

  gArmTokenSpaceGuid.PcdVFPEnabled|1

  #
  # ARM PrimeCell
  #

  ## PL011 - Serial Terminal

  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterBase|0x7FF80000
  gEfiMdePkgTokenSpaceGuid.PcdUartDefaultBaudRate|115200
!ifdef $(ASHBROOK_EMULATOR)
  gArmPlatformTokenSpaceGuid.PL011UartInteger|1
  gArmPlatformTokenSpaceGuid.PL011UartFractional|0
!else
  gArmPlatformTokenSpaceGuid.PL011UartInteger|4
  gArmPlatformTokenSpaceGuid.PL011UartFractional|0
!endif

  ## PL180 MMC/SD card controller


  ## PL031 RealTimeClock
  gArmPlatformTokenSpaceGuid.PcdPL031RtcBase|0x1C170000

!ifdef EDK2_ENABLE_SMSC_91X
  # Ethernet (SMSC 91C111)
  gLan91xDxeTokenSpaceGuid.PcdLan91xDxeBaseAddress|0x18000000
!endif


  #
  # ARM General Interrupt Controller
  #
  gArmTokenSpaceGuid.PcdGicDistributorBase|0x30000000
  gArmTokenSpaceGuid.PcdGicRedistributorsBase|0x30400000
!ifdef $(ASHBROOK_EMULATOR)
  !if $(ASHBROOK_VARIANT) == 2
    gArmTokenSpaceGuid.PcdGicRedistributorsBase|0x30200000
  !endif
!else
  !if $(ASHBROOK_VARIANT) == 2
    gArmTokenSpaceGuid.PcdGicRedistributorsBase|0x30800000
  !endif
!endif

  # List of Device Paths that support BootMonFs
  gArmPlatformTokenSpaceGuid.PcdBootMonFsSupportedDevicePaths|L"VenHw(E7223039-5836-41E1-B542-D7EC736C5E59)"

  #
  # ARM OS Loader
  #

  # Configured for Default Mainline Linux Kernel Boot
  #
  gEfiMdeModulePkgTokenSpaceGuid.PcdDramBootDescription|L"Linux from DRAM"
  gEfiMdeModulePkgTokenSpaceGuid.PcdDramBootDevicePath|L"VenHw(30F57E4A-69CE-4FB7-B7A1-4C7CE49D57A6)/MemoryMapped(0x0,0x80080000,0x81000000)"
  gEfiMdeModulePkgTokenSpaceGuid.PcdDramBootArgument|"initrd=0x88000000,0x00200000 acpi=force console=ttyAMA0,115200 earlycon=pl011,0x7FF80000 root=/dev/vda2 rootwait verbose debug"
!ifdef $(ASHBROOK_EMULATOR)
  gEfiMdePkgTokenSpaceGuid.PcdPlatformBootTimeOut|0
!else
  gEfiMdePkgTokenSpaceGuid.PcdPlatformBootTimeOut|10
!endif

  # Use the serial console (ConIn & ConOut) and the Graphic driver (ConOut)
  gArmPlatformTokenSpaceGuid.PcdDefaultConOutPaths|L"VenHw(D3987D4B-971A-435F-8CAF-4967EB627241)/Uart(115200,8,N,1)/VenPcAnsi()"
  gArmPlatformTokenSpaceGuid.PcdDefaultConInPaths|L"VenHw(D3987D4B-971A-435F-8CAF-4967EB627241)/Uart(115200,8,N,1)/VenPcAnsi()"

  #
  # ARM Architectural Timer Frequency
  #
  gArmTokenSpaceGuid.PcdArmArchTimerFreqInHz|10000000
  gEmbeddedTokenSpaceGuid.PcdMetronomeTickPeriod|1000
  gEmbeddedTokenSpaceGuid.PcdTimerPeriod|100000000

[PcdsPatchableInModule]
  # Console Resolution (Full HD)
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|1920
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|1080

################################################################################
#
# Components Section - list of all EDK II Modules needed by this Platform
#
################################################################################
[Components.common]
  #
  # PEI Phase modules
  #
  ArmPlatformPkg/PrePi/PeiMPCore.inf

  #
  # DXE
  #
  MdeModulePkg/Core/Dxe/DxeMain.inf {
    <LibraryClasses>
      PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
      NULL|MdeModulePkg/Library/DxeCrc32GuidedSectionExtractLib/DxeCrc32GuidedSectionExtractLib.inf
  }

  #
  # Architectural Protocols
  #
  ArmPkg/Drivers/CpuDxe/CpuDxe.inf
  MdeModulePkg/Core/RuntimeDxe/RuntimeDxe.inf
  MdeModulePkg/Universal/SecurityStubDxe/SecurityStubDxe.inf
  MdeModulePkg/Universal/CapsuleRuntimeDxe/CapsuleRuntimeDxe.inf
  MdeModulePkg/Universal/MonotonicCounterRuntimeDxe/MonotonicCounterRuntimeDxe.inf
  EmbeddedPkg/ResetRuntimeDxe/ResetRuntimeDxe.inf
  EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf
  EmbeddedPkg/MetronomeDxe/MetronomeDxe.inf

  MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
  MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf
  MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
  MdeModulePkg/Universal/Console/TerminalDxe/TerminalDxe.inf
  MdeModulePkg/Universal/SerialDxe/SerialDxe.inf

!ifdef $(ASHBROOK_EMULATOR)
  MdeModulePkg/Universal/Variable/EmuRuntimeDxe/EmuVariableRuntimeDxe.inf
!else
  MdeModulePkg/Universal/Variable/RuntimeDxe/VariableRuntimeDxe.inf
  MdeModulePkg/Universal/FaultTolerantWriteDxe/FaultTolerantWriteDxe.inf
!endif

  #
  # ACPI Support
  #
  MdeModulePkg/Universal/Acpi/AcpiTableDxe/AcpiTableDxe.inf
  MdeModulePkg/Universal/Acpi/AcpiPlatformDxe/AcpiPlatformDxe.inf
!if $(ASHBROOK_VARIANT) == 2
  OpenPlatformPkg/Platforms/ARM/css-enterprise/AcpiTables/Ashbrook_2/AcpiTables.inf
!else
  OpenPlatformPkg/Platforms/ARM/css-enterprise/AcpiTables/Ashbrook_5/AcpiTables.inf
!endif
  MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf

  ArmPkg/Drivers/ArmGic/ArmGicDxe.inf
!ifndef $(ASHBROOK_EMULATOR)
  ArmPlatformPkg/Drivers/NorFlashDxe/NorFlashDxe.inf
  OvmfPkg/VirtioBlkDxe/VirtioBlk.inf
  #
  # Semi-hosting filesystem
  #
  ArmPkg/Filesystem/SemihostFs/SemihostFs.inf
!endif
  ArmPkg/Drivers/TimerDxe/TimerDxe.inf
  ArmPkg/Drivers/GenericWatchdogDxe/GenericWatchdogDxe.inf

  #
  # Ashbrook development platform driver
  #
  OpenPlatformPkg/Platforms/ARM/css-enterprise/Drivers/AshbrookDxe/AshbrookDxe.inf

  #
  # Multimedia Card Interface
  #


  #
  # FAT filesystem + GPT/MBR partitioning
  #
  MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
  MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
  MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf

  # Networking stack

  #


  #
  # Bds
  #
  MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf
  MdeModulePkg/Universal/DisplayEngineDxe/DisplayEngineDxe.inf
  MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
  MdeModulePkg/Universal/BdsDxe/BdsDxe.inf
  MdeModulePkg/Application/UiApp/UiApp.inf {
    <LibraryClasses>
      NULL|MdeModulePkg/Library/DeviceManagerUiLib/DeviceManagerUiLib.inf
      NULL|MdeModulePkg/Library/BootManagerUiLib/BootManagerUiLib.inf
      NULL|MdeModulePkg/Library/BootMaintenanceManagerUiLib/BootMaintenanceManagerUiLib.inf
  }
