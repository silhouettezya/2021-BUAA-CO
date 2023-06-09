/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000000361761305_3224323566_init();
    work_m_00000000001901043030_0757879789_init();
    work_m_00000000003613505985_3901337038_init();
    work_m_00000000002008208835_1785967555_init();
    work_m_00000000003413151054_1621229167_init();
    work_m_00000000001795394835_0886308060_init();
    work_m_00000000000842044086_2924402094_init();
    work_m_00000000001426589933_3877310806_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000001426589933_3877310806");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}