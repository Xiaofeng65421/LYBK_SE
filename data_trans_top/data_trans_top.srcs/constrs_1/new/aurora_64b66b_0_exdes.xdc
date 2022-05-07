##################################################################################
##
## Project:  Aurora 64B/66B
## Company:  Xilinx
##
##
##
## (c) Copyright 2008 - 2018 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.
##
###################################################################################################
##
##  aurora_64b66b_0_exdes
##
##  Description: This is the example design constraints file for a 1 lane Aurora
##               core.
##               This is example design xdc.
##               Note: User need to set proper IO standards for the LOC's mentioned below.
###################################################################################################

# Reference clock contraint for GTX
# false path constrints for example design paths
# Reference clock location
set_property PACKAGE_PIN AF9 [get_ports GTH_N_0]
set_property PACKAGE_PIN AF10 [get_ports GTH_P_0]

set_property PACKAGE_PIN V33 [get_ports GTH_N_1]
set_property PACKAGE_PIN V32 [get_ports GTH_P_1]

#SLOT 2
set_property PACKAGE_PIN AW4 [get_ports {RXP_0[0]}]
set_property PACKAGE_PIN AW3 [get_ports {RXN_0[0]}]
set_property PACKAGE_PIN AW8 [get_ports {TXP_0[0]}]
set_property PACKAGE_PIN AW7 [get_ports {TXN_0[0]}]
#SLOT 3
set_property PACKAGE_PIN AU4 [get_ports {RXP_0[1]}]
set_property PACKAGE_PIN AU3 [get_ports {RXN_0[1]}]
set_property PACKAGE_PIN AU8 [get_ports {TXP_0[1]}]
set_property PACKAGE_PIN AU7 [get_ports {TXN_0[1]}]
#SLOT 4
set_property PACKAGE_PIN AR4 [get_ports {RXP_0[2]}]
set_property PACKAGE_PIN AR3 [get_ports {RXN_0[2]}]
set_property PACKAGE_PIN AR8 [get_ports {TXP_0[2]}]
set_property PACKAGE_PIN AR7 [get_ports {TXN_0[2]}]
#SLOT 5
set_property PACKAGE_PIN AN4 [get_ports {RXP_0[3]}]
set_property PACKAGE_PIN AN3 [get_ports {RXN_0[3]}]
set_property PACKAGE_PIN AN8 [get_ports {TXP_0[3]}]
set_property PACKAGE_PIN AN7 [get_ports {TXN_0[3]}]
#SLOT 6 : DAC
set_property PACKAGE_PIN AL4 [get_ports {RXP_0[4]}]
set_property PACKAGE_PIN AL3 [get_ports {RXN_0[4]}]
set_property PACKAGE_PIN AL8 [get_ports {TXP_0[4]}]
set_property PACKAGE_PIN AL7 [get_ports {TXN_0[4]}]

set_property PACKAGE_PIN AK2 [get_ports {RXP_0[5]}]
set_property PACKAGE_PIN AK1 [get_ports {RXN_0[5]}]
set_property PACKAGE_PIN AK6 [get_ports {TXP_0[5]}]
set_property PACKAGE_PIN AK5 [get_ports {TXN_0[5]}]
#SLOT 7 : ADDA
set_property PACKAGE_PIN AJ4 [get_ports {RXP_0[6]}]
set_property PACKAGE_PIN AJ3 [get_ports {RXN_0[6]}]
set_property PACKAGE_PIN AJ8 [get_ports {TXP_0[6]}]
set_property PACKAGE_PIN AJ7 [get_ports {TXN_0[6]}]

set_property PACKAGE_PIN AH2 [get_ports {RXP_0[7]}]
set_property PACKAGE_PIN AH1 [get_ports {RXN_0[7]}]
set_property PACKAGE_PIN AH6 [get_ports {TXP_0[7]}]
set_property PACKAGE_PIN AH5 [get_ports {TXN_0[7]}]
#SLOT 9 : DAC
set_property PACKAGE_PIN AG38 [get_ports {RXP_1[0]}]
set_property PACKAGE_PIN AG39 [get_ports {RXN_1[0]}]
set_property PACKAGE_PIN AH36 [get_ports {TXP_1[0]}]
set_property PACKAGE_PIN AH37 [get_ports {TXN_1[0]}]

set_property PACKAGE_PIN AF36 [get_ports {RXP_1[1]}]
set_property PACKAGE_PIN AF37 [get_ports {RXN_1[1]}]
set_property PACKAGE_PIN AG34 [get_ports {TXP_1[1]}]
set_property PACKAGE_PIN AG35 [get_ports {TXN_1[1]}]
#SLOT 10 : DAC
set_property PACKAGE_PIN AE38 [get_ports {RXP_1[2]}]
set_property PACKAGE_PIN AE39 [get_ports {RXN_1[2]}]
set_property PACKAGE_PIN AE34 [get_ports {TXP_1[2]}]
set_property PACKAGE_PIN AE35 [get_ports {TXN_1[2]}]

set_property PACKAGE_PIN AC38 [get_ports {RXP_1[3]}]
set_property PACKAGE_PIN AC39 [get_ports {RXN_1[3]}]
set_property PACKAGE_PIN AD36 [get_ports {TXP_1[3]}]
set_property PACKAGE_PIN AD37 [get_ports {TXN_1[3]}]
#SLOT 11
set_property PACKAGE_PIN AB36 [get_ports {RXP_1[4]}]
set_property PACKAGE_PIN AB37 [get_ports {RXN_1[4]}]
set_property PACKAGE_PIN AC34 [get_ports {TXP_1[4]}]
set_property PACKAGE_PIN AC35 [get_ports {TXN_1[4]}]
#SLOT 12
set_property PACKAGE_PIN W38 [get_ports {RXP_1[5]}]
set_property PACKAGE_PIN W39 [get_ports {RXN_1[5]}]
set_property PACKAGE_PIN Y36 [get_ports {TXP_1[5]}]
set_property PACKAGE_PIN Y37 [get_ports {TXN_1[5]}]
#SLOT 13
set_property PACKAGE_PIN U38 [get_ports {RXP_1[6]}]
set_property PACKAGE_PIN U39 [get_ports {RXN_1[6]}]
set_property PACKAGE_PIN U34 [get_ports {TXP_1[6]}]
set_property PACKAGE_PIN U35 [get_ports {TXN_1[6]}]
#SLOT 14
set_property PACKAGE_PIN P36 [get_ports {RXP_1[7]}]
set_property PACKAGE_PIN P37 [get_ports {RXN_1[7]}]
set_property PACKAGE_PIN R34 [get_ports {TXP_1[7]}]
set_property PACKAGE_PIN R35 [get_ports {TXN_1[7]}]





# create_clock -period 5.000 -name gt_refclk1_in [get_ports GTH_P_0]
# create_clock -period 5.000 -name gt_refclk2_in [get_ports GTH_P_1]
# set_clock_groups -asynchronous -group [get_clocks gt_refclk1_in -include_generated_clocks]
# set_clock_groups -asynchronous -group [get_clocks gt_refclk2_in -include_generated_clocks]
# set_false_path -to [get_pins -hier *aurora_64b66b_0_cdc_to*/D]

####################################################################################
# Constraints from file : 'ddr_pin.xdc'
####################################################################################





