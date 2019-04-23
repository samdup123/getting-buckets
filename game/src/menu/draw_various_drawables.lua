return function(graphics, fonts, images)
    local font
    return function(drawable)
        if drawable and drawable.invisible then return end
        drawable = drawable or {}
        graphics.setColor(drawable.red or 0, drawable.green or 0, drawable.blue or 0, drawable.alpha or 100)
        if drawable.string then
            font = fonts[drawable.font]
            graphics.setFont(font)

            if drawable.limit then
                local _, strings = font:getWrap(drawable.string, drawable.limit)
                local _string = table.concat(strings, '\n')
                graphics.print(
                    _string,
                    drawable.x,
                    drawable.y)
            else
                graphics.print(
                    drawable.string,
                    drawable.x,
                    drawable.y,
                    nil, nil, nil,
                    font:getWidth(drawable.string)/2,
                    font:getHeight()/2)
            end
        elseif drawable.r then
            graphics.circle(drawable.mode, drawable.x, drawable.y, drawable.r)
        elseif drawable.width then
            graphics.rectangle(drawable.mode, drawable.x, drawable.y, drawable.width, drawable.height)
        elseif drawable.x1 then
            graphics.polygon(
                drawable.mode,
                drawable.x1,
                drawable.y1,
                drawable.x2,
                drawable.y2,
                drawable.x3,
                drawable.y3)
        elseif drawable.image then
            print(drawable.image)
            graphics.draw(images[drawable.image], drawable.x, drawable.y)
        end
    end
end
