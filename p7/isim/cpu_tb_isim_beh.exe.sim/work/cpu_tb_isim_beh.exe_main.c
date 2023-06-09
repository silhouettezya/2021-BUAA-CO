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
    work_m_00000000001401630990_2784194153_init();
    work_m_00000000002594993450_3097610606_init();
    work_m_00000000000183930291_0060011589_init();
    work_m_00000000004134015670_4235459488_init();
    work_m_00000000003675876420_2663932823_init();
    work_m_00000000003310764324_2484743739_init();
    work_m_00000000001053557974_2862431528_init();
    work_m_00000000001087910388_3650585529_init();
    work_m_00000000001664446093_3239301648_init();
    work_m_00000000000057691318_4245161272_init();
    work_m_00000000001610974955_2831923789_init();
    work_m_00000000003316893464_4049836497_init();
    work_m_00000000000705466926_1158014626_init();
    work_m_00000000004040381797_2122491343_init();
    work_m_00000000001250037473_0357782045_init();
    work_m_00000000003997643253_3677558514_init();
    work_m_00000000003662809246_3508565487_init();
    work_m_00000000003797160891_4263217831_init();
    work_m_00000000000056312757_0053799672_init();
    work_m_00000000001127168877_3877310806_init();
    work_m_00000000001292392995_1912994691_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000001292392995_1912994691");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
