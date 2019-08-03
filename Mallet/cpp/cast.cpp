//
//  cast.cpp
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/03.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

#include "cast.hpp"

ControlCode getControlCode(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return std::get<ControlCode>(variable);
    }
    else
    {
        return ControlCode::NONE;
    }

    return ControlCode::NONE;
}

int getIntValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<int>(variable))
    {
        return std::get<int>(variable);
    }

    if (std::holds_alternative<double>(variable))
    {
        return (int)std::get<double>(variable);
    }

    if (std::holds_alternative<bool>(variable))
    {
        return std::get<bool>(variable) ? 1 : 0;
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return (int)strtol(std::get<std::string>(variable).c_str(), NULL, 10);
    }

    return 0;
}

double getNumberValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<int>(variable))
    {
        return (double)std::get<int>(variable);
    }

    if (std::holds_alternative<double>(variable))
    {
        return std::get<double>(variable);
    }

    if (std::holds_alternative<bool>(variable))
    {
        return (double)std::get<bool>(variable);
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return strtod(std::get<std::string>(variable).c_str(), NULL);
    }

    return 0;
}

bool getBoolValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<int>(variable))
    {
        return std::get<int>(variable) > 0;
    }

    if (std::holds_alternative<double>(variable))
    {
        return std::get<double>(variable) > 0;
    }

    if (std::holds_alternative<bool>(variable))
    {
        return std::get<bool>(variable);
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return false;
    }

    return false;
}

std::string getStringValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return 0;
    }

    if (std::holds_alternative<int>(variable))
    {
        return "";
    }

    if (std::holds_alternative<double>(variable))
    {
        return std::to_string(std::get<double>(variable));
    }

    if (std::holds_alternative<bool>(variable))
    {
        return std::get<bool>(variable) ? "1" : "0";
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return std::get<std::string>(variable);
    }

    return "";
}

std::string getOutValue(var &variable)
{
    if (std::holds_alternative<ControlCode>(variable))
    {
        return "";
    }

    if (std::holds_alternative<int>(variable))
    {
        return std::to_string(std::get<int>(variable));
    }

    if (std::holds_alternative<double>(variable))
    {
        std::ostringstream strstream;
        strstream << std::noshowpoint << std::setprecision(20) << std::get<double>(variable);

        return strstream.str();
    }

    if (std::holds_alternative<bool>(variable))
    {
        return std::get<bool>(variable) ? "1" : "0";
    }

    if (std::holds_alternative<std::string>(variable))
    {
        return std::get<std::string>(variable);
    }

    return "";
}