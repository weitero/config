#!/usr/bin/env python3
#https://gitlab.com/gnachman/iterm2/-/issues/9683
#https://iterm2.com/python-api/examples/theme.html#change-color-presets-on-theme-change
import iterm2


async def update(connection,theme):
    parts=theme.split(' ')
    if 'dark' in parts:
        brighten_bold=True
        preset=await iterm2.ColorPreset.async_get(connection,'vscode')
    else:
        brighten_bold=False
        preset=await iterm2.ColorPreset.async_get(connection,'vscode-light')

    profiles=await iterm2.PartialProfile.async_query(connection)
    for partial in profiles:
        profile=await partial.async_get_full_profile()
        await profile.async_set_brighten_bold_text(brighten_bold)
        await profile.async_set_color_preset(preset)


async def main(connection):
    app=await iterm2.async_get_app(connection)
    await update(connection,await app.async_get_variable('effectiveTheme'))
    async with iterm2.VariableMonitor(connection,iterm2.VariableScopes.APP,'effectiveTheme',None) as mon:
        while True:
            theme=await mon.async_get()
            await update(connection,theme)


iterm2.run_forever(main)
