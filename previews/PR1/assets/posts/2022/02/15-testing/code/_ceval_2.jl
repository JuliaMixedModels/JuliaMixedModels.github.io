# This file was generated, do not modify it. # hide
using CairoMakie
using MixedModels
using MixedModelsMakie
using MKL
fm1 = fit(MixedModel, @formula(reaction ~ 1 + days + (1+days|subj)), MixedModels.dataset(:sleepstudy))
shrinkageplot(fm1)
