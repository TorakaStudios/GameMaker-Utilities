/// @desc Check that the given value is a specific type, or an array of specific types. IF IT IS NOT, AN ERROR WILL BE THROWN!
///         For this function, a value of noone is ALL TYPES. This mimics behaviour in other languages where null is a valid value of any type.
///         If you do not want this behaviour, remove the starting if block, or change noone to your "empty" value of choice.
///         It is recommended to have some "empty" value exception like this, such that you can safely typecheck an empty value.
/// @param {any} _value The value to check.
/// @param {any} _type The type that _value should be. If _value should be an array, object, or constructor, you should pass a second_type and maybe third_type for meaningful results.
///                     If _type is Type.ARRAY, it will be checked that _value is an array, and that EVERY element of the array conforms to the second/third type given.
///                     In effect, is_type(_value[i], _second_type, _third_type) will be called for each i from 0 to array_length(_value)
///                     If _type is Type.OBJECT, you should pass the object index as _second_type, just like if you called instance_create: is_type(_button, Type.OBJECT, obj_button);
///                     The value will be checked for either being an instance of the given object index or inheriting from it.
///                     E.g. if you have obj_cat with obj_animal set as its parent, and _cat is an instance of obj_cat, then is_type(_cat, Type.OBJECT, obj_animal) will pass.
///                     If _type is Type.CONSTRUCTOR, you should pass the constructor function as _second_type, just like if you called it with new: is_type(_idol, Type.CONSTRUCTOR, Idol);
///                     The value will be checked for being a struct that either is an instance of the given constructor function or inherits from it.
/// @param {any*} [_second_type] Optional. If _type is Type.ARRAY, is used to specify what type of values the array should have. You may typecheck for an array of arrays, or an array of objects/constructors!
///                     If _type is Type.OBJECT, or Type.CONSTRUCTOR, is used to specify what kind of instance _value should be.
/// @param {any*} [_third_type] Optional. If _value should be an array of arrays, objects, or constructors, this argument specifies what kind of instance should be in the (inner) array.
function is_type(_value, _type, _second_type = undefined, _third_type = undefined) {
	if (_value == noone) {
		return;
	}
	var _is_type = true;
	
	switch (_type) {
		case Type.BOOLEAN:
			_is_type = is_bool(_value);
			break;
		case Type.SPRITE:
			_is_type = sprite_exists(_value) && is_numeric(_value);
			break;
		case Type.SOUND:
			_is_type = audio_exists(_value) && is_numeric(_value);
			break;
		case Type.NUMBER:
		case Type.ENUM:
		case Type.COLOUR:
			_is_type = is_numeric(_value);
			break;
		case Type.STRING:
			_is_type = is_string(_value);
			break;
		case Type.METHOD:
			_is_type = is_method(_value);
			break;
		case Type.CALLABLE:
			_is_type = is_callable(_value);
			break;
		case Type.STRUCT:
			_is_type = is_struct(_value);
			break;
		case Type.ARRAY:
			_is_type = is_array(_value);
			if (_second_type == undefined) {
				break;
			}
			for (var i = 0; i < array_length(_value); i++) {
				is_type(_value[i], _second_type, _third_type);
			}
			break;
        case Type.CONSTRUCTOR:
            var _constructor_type = _second_type;
            _is_type = is_struct(_value) && is_instanceof(_value, _constructor_type);
            break;
        case Type.OBJECT:
            var _object_type = _second_type;
            _is_type = _value.object_index == _object_type || object_is_ancestor(_value.object_index, _object_type);
            break;
		default:
			_is_type = false;
			break;
	}
    
	if (!_is_type) {
		throw ("Object was not of the expected type " + string(_type));
	}
}

enum Type {
	BOOLEAN = -200,
	SPRITE = -199,
	SOUND = -198,
	NUMBER = -197,
	ENUM = -196,
	COLOUR = -195,
	STRING = -194,
	METHOD = -193,
	CALLABLE = -192,
	STRUCT = -191,
	ARRAY = -190,
    CONSTRUCTOR = -189,
    OBJECT = -188
}

