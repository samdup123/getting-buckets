return function(graphics)
    return function(drawable)
        drawable = drawable or {}
        graphics.setColor(drawable.red or 0, drawable.green or 0, drawable.blue or 0, drawable.alpha or 100)
        if drawable.string then
            graphics.print(drawable.string, drawable.x, drawable.y)
        elseif drawable.r then
            graphics.circle(drawable.mode, drawable.x, drawable.y, drawable.r)
        elseif drawable.width then
            graphics.rectangle(drawable.mode, drawable.x, drawable.y, drawable.width, drawable.height)
        end
    end
end
